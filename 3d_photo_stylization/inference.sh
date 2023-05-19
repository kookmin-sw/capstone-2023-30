#!/bin/bash
DEVICE_NUM=0

cd inpainting 경로
CUDA_VISIBLE_DEVICES=${DEVICE_NUM} python3 main.py --config argument.yml

cd ..
cd stylization 경로
CUDA_VISIBLE_DEVICES=${DEVICE_NUM} python3 test_ldi.py \
    -m pretrain/style/model/path \
    -ldi LDI/path \
    -s style/image/path -cam "zoom" -ndc -pc 2

cd ..
cd inpainting 경로
CUDA_VISIBLE_DEVICES=${DEVICE_NUM} python3 main.py --config argument.yml