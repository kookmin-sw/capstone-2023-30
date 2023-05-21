from django.http import JsonResponse
from django.http import FileResponse
from django.views.decorators.csrf import csrf_exempt

import subprocess
import time
import os
from PIL import Image
import io

inpainting_model_path = '../../3d-photo-inpainting/'


# Create your views here.
@csrf_exempt
def index(request):
    inpainting = True
    stylizing = True

    # Check working directory.
    if os.getcwd().split('/')[-1] != 'server_django':
        os.chdir('../backend/server_django')
    
    # Get Style number. default = -1.
    style_num = int(request.GET.get('style_num')) if request.GET.get('style_num') != None else -1
    print('style_num =', style_num)

    file_name = request.GET.get('img_name')
    if file_name == None:
        return JsonResponse({'status': "400", "success": False, "message":"Please insert image name as Get method."}, status=400)
    try:
        file_name, file_format = file_name.split('.')
    except Exception as e:
        return JsonResponse({'status': "400", "success": False, "message": f"Wrong file name. {str(e)}"}, status=400)


    # if style != -1, Check mesh first to skip first inpainting.
    if style_num != -1:
        if os.path.isfile(inpainting_model_path+'mesh/'+file_name+'.mat'):
            print('mat file found. skip inpainting.')
            inpainting = False
        else:
            print('cannot find mat file. Starting inpainting model.')
    else:
        print('Skipping Stylizing model.')
        stylizing = False

    
    response = None

    if inpainting:
        # Get Requested image data, fime format & file name
        image_raw = request.body
        if image_raw == b'':
            return JsonResponse({'status': "400", "success": False, "message":"Request body is Empty."}, status=400)
        
        # Save Image as JPG
        try:
            image = Image.open(io.BytesIO(image_raw))
            if file_format.lower() == 'png':
                rgb_image = image.convert('RGB')
                rgb_image.save(f'{inpainting_model_path}image/{file_name}.jpg', format='JPEG', quality=100)
            else:
                image.save(f'{inpainting_model_path}image/{file_name}.jpg')
            
            print('[LOG] Image processing complete')

        except Exception as e:
            return JsonResponse({'status': "500", "success": False, "message":"Error occured while image processing. "+str(e)}, status=500)
        
        # Run AI model
        try:
            print("[LOG] Starting inpainting model ============\n")
            os.chdir(inpainting_model_path)
            pid = subprocess.Popen(['python', 'main.py', 
                                    '--config', 'argument.yml', '--image_name', file_name, 
                                    '--save_ldi', 't', 
                                    '--save_ply', 't' if not stylizing else 'f'])

            while pid.poll() is None:
                time.sleep(1)
            
            print("[LOG] ============\n"+"[LOG] Process result :", pid.returncode)

        except Exception as e:
            return JsonResponse({'status': "500", "success": False, "message":"Error occured while running Inpainting AI model. "+str(e)}, status=500)

    if stylizing:
        if os.getcwd().split('/')[-1] == 'server_django':
            os.chdir('../../3d_photo_stylization')
        else:
            os.chdir('../3d_photo_stylization')

        try:
            print("[LOG] Starting stylization model ============\n")
            pid = subprocess.Popen(
                ['python', 'test_ldi.py', 
                 '-m', 'ckpt/r3/stylize.pth', 
                 '-ldi', f'../3d-photo-inpainting/mesh/{file_name}.mat', 
                 '-s', f'samples/style/{style_num}.jpg', 
                 '-cam', 'zoom', 
                 '-ndc', '-pc', '2']
            )

            while pid.poll() is None:
                time.sleep(1)
            
            print("[LOG] ============\n"+"[LOG] Process result :", pid.returncode)

        except Exception as e:
            return JsonResponse({'status': "500", "success": False, "message":"Error occured while running Stylization AI model. "+str(e)}, status=500)
        
        subprocess.run(['cp', f'stylized/{file_name}.jpg', '../3d-photo-inpainting/image'])
        
        try:
            os.chdir('../3d-photo-inpainting')

            print("[LOG] Starting inpainting model ============\n")
            pid = subprocess.Popen(['python', 'main.py', 
                                    '--config', 'argument.yml', 
                                    '--image_name', file_name, 
                                    '--save_ldi', 'f', '--save_ply', 't'])

            while pid.poll() is None:
                time.sleep(1)
            
            print("[LOG] ============\n"+"[LOG] Process result :", pid.returncode)

        except Exception as e:
            return JsonResponse({'status': "500", "success": False, "message":"Error occured while running Inpainting AI model. "+str(e)}, status=500)


    # Set File response
    response = FileResponse(
        open(f'mesh/{file_name}.ply', 'rb')
    )
    response['Content-Type'] = 'application/octet-stream'
    response['Content-Disposition'] = f'attachment; filename="{file_name}.ply"'

    return response
