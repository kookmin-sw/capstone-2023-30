#!/bin/bash
DEVICE_NUM=0
scenes="00042 00322 00439 00807"
cam="zoom dolly_zoom ken_burns swing circle static"

for scene in $scenes
do
    python3 ldi_render.py -ldi "/home/hyunji/3d_photo_stylization/samples/ldi/unsplash/${scene}.mat" -cam "circle"
done