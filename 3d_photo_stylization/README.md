## 셸스크립트 설명

- test_lid.py: test(inference)시에 돌리는 파일
- -m: pretrain style 모델 체크포인트 경로
- -ldi: style이 입혀지는 대상 (.mat 형식)
- -s: 입힐 style에 해당하는 이미지
- -cam: 동영상 촬영을 위해서 필요한 카메라 path 선택 (option: 'zoom', 'dolly_zoom', 'ken_burns', 'swing', 'circle', 'static')
- -ndc, -pc 2 는 고정으로 사용합니다.

ex) python3 test_ldi.py -m "/home/hyunji/3d_photo_stylization/ckpt/r3/stylize.pth" \
  -ldi "/home/hyunji/3d_photo_stylization/samples/ldi/cat2.mat" \
  -s "/home/hyunji/3d_photo_stylization/samples/style/30.jpg" \
  -cam "circle" -ndc -pc 2
