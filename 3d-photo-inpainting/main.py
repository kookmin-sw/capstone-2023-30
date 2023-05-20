import numpy as np
import argparse
import os
from tqdm import tqdm
import yaml
import time
from mesh import write_ply
from utils import get_MiDaS_samples, read_MiDaS_depth
import torch
import cv2
import imageio
from networks import Inpaint_Color_Net, Inpaint_Depth_Net, Inpaint_Edge_Net
from MiDaS.run import run_depth
from boostmonodepth_utils import run_boostmonodepth
from MiDaS.monodepth_net import MonoDepthNet
import MiDaS.MiDaS_utils as MiDaS_utils
from bilateral_filtering import sparse_bilateral_filtering

parser = argparse.ArgumentParser()
parser.add_argument('--config', type=str, default='argument.yml',help='Configure of post processing')
parser.add_argument('--image_name', type=str, default='', help='target image name in ./image directory')
args = parser.parse_args()
config = yaml.full_load(open(args.config, 'r'))

os.makedirs(config['mesh_folder'], exist_ok=True)
os.makedirs(config['video_folder'], exist_ok=True)
os.makedirs(config['depth_folder'], exist_ok=True)
sample_list = get_MiDaS_samples(config['src_folder'], config['depth_folder'], config, config['specific'])
normal_canvas, all_canvas = None, None

if isinstance(config["gpu_ids"], int) and (config["gpu_ids"] >= 0):
    device = config["gpu_ids"]
else:
    device = "cpu"

print(f"running on device {device}")

# 추가 코드: 시간 측정
start_time = time.time()
if args.image_name != '':
    config['specific'] = args.image_name

depth = None
sample = sample_list[0]

print("Current Source ==> ", sample['src_pair_name'])
mesh_fi = os.path.join(config['mesh_folder'], sample['src_pair_name'] +'.ply')
image = imageio.imread(sample['ref_img_fi'])

print(f"Running depth extraction at {time.time()-start_time}")
if config['use_boostmonodepth'] is True:
    run_boostmonodepth(sample['ref_img_fi'], config['src_folder'], config['depth_folder'])
elif config['require_midas'] is True:
    run_depth([sample['ref_img_fi']], config['src_folder'], config['depth_folder'],
                config['MiDaS_model_ckpt'], MonoDepthNet, MiDaS_utils, target_w=640)

if 'npy' in config['depth_format']:
    config['output_h'], config['output_w'] = np.load(sample['depth_fi']).shape[:2]
else:
    config['output_h'], config['output_w'] = imageio.imread(sample['depth_fi']).shape[:2]

frac = config['longer_side_len'] / max(config['output_h'], config['output_w'])
config['output_h'], config['output_w'] = int(config['output_h'] * frac), int(config['output_w'] * frac)
config['original_h'], config['original_w'] = config['output_h'], config['output_w']

if image.ndim == 2:
    image = image[..., None].repeat(3, -1)
if np.sum(np.abs(image[..., 0] - image[..., 1])) == 0 and np.sum(np.abs(image[..., 1] - image[..., 2])) == 0:
    config['gray_image'] = True
else:
    config['gray_image'] = False

image = cv2.resize(image, (config['output_w'], config['output_h']), interpolation=cv2.INTER_AREA)
depth = read_MiDaS_depth(sample['depth_fi'], 3.0, config['output_h'], config['output_w'])
mean_loc_depth = depth[depth.shape[0]//2, depth.shape[1]//2]

if not(config['load_ply'] is True and os.path.exists(mesh_fi)):
    vis_photos, vis_depths = sparse_bilateral_filtering(depth.copy(), image.copy(), config, num_iter=config['sparse_iter'], spdb=False)
    depth = vis_depths[-1]
    model = None
    torch.cuda.empty_cache()
    print("Start Running 3D_Photo ...")

    print(f"Loading edge model at {time.time()-start_time}")
    depth_edge_model = Inpaint_Edge_Net(init_weights=True)
    depth_edge_weight = torch.load(config['depth_edge_model_ckpt'],
                                    map_location=torch.device(device))
    depth_edge_model.load_state_dict(depth_edge_weight)
    depth_edge_model = depth_edge_model.to(device)
    depth_edge_model.eval()

    print(f"Loading depth model at {time.time()-start_time}")
    depth_feat_model = Inpaint_Depth_Net()
    depth_feat_weight = torch.load(config['depth_feat_model_ckpt'],
                                    map_location=torch.device(device))
    depth_feat_model.load_state_dict(depth_feat_weight, strict=True)
    depth_feat_model = depth_feat_model.to(device)
    depth_feat_model.eval()
    depth_feat_model = depth_feat_model.to(device)

    print(f"Loading rgb model at {time.time()-start_time}")
    rgb_model = Inpaint_Color_Net()
    rgb_feat_weight = torch.load(config['rgb_feat_model_ckpt'],
                                    map_location=torch.device(device))
    rgb_model.load_state_dict(rgb_feat_weight)
    rgb_model.eval()
    rgb_model = rgb_model.to(device)
    graph = None

    print(f"Writing depth ply (and basically doing everything) at {time.time()-start_time}")
    rt_info = write_ply(image,
                            depth,
                            sample['int_mtx'],
                            mesh_fi,
                            config,
                            rgb_model,
                            depth_edge_model,
                            depth_edge_model,
                            depth_feat_model)
    
    print(f'Total inference Time : {int(time.time() - start_time) // 60} min {int(time.time() - start_time) % 60} sec.')
