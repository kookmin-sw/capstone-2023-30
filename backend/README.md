# Back-End
## 기능
---
<br>
<img src="./resources/aws_map.png" alt="moving cat">
<br>
<br>

Front-end에서 넘겨받은 이미지를 입력으로 AI 모델 구동 후, 이에 따른 출력인 ".ply" 파일을 S3 서버에 저장한다. 이후 저장된 ".ply" 파일에 대한 Pre-signed URL을 Front-end로 반환한다.

<br>
<br>

## 사용 기술
---
| 분류 | 세부 | 용도 |
| --- | --- | --- |
| <b>AWS | Api Gateway | HTTP 요청을 Lambda로 Forwarding |
| | Lambda | EC2 및 S3 간 데이터 전달 및 상호작용 |
| | S3 | ".ply" 파일 저장 및 Pre-signed URL 배포 |
| | EC2 | AI 구동 용 인스턴스 |
| <b>Server | Spring | AI 모델 구동 |

<br>
<br>

## 담당자
---
<b>임중혁</b>(****1683)
<br>
<b>E-mail</b>: bungae1112@gmail.com
<br>
<b>Github</b>: <a href="https://github.com/Angheng"><b>Angheng</b></a>

