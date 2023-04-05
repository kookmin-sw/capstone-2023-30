import json
import boto3
import base64
from datetime import datetime


def lambda_handler(event, context):
    
    
    s3 = boto3.resource('s3')
    req_time = datetime.now().strftime('%y%m%d_%H%M%S')
    
    res = {
        "status": 200,
        "success": False,
        "message": ''
    }
    
    try:
        # Check HTTP method.
        test = 1
        if event['httpMethod'] != 'POST':
            raise Exception('HTTP method is not POST. Please use POST.')
        
        # Check image size format
        raw_size = event['pathParameters']['size']
        size = []
        if 'x' in raw_size:
            size = list(map(int, raw_size.split('x')))
        elif 'X' in raw_size:
            size = list(map(int, raw_size.split('X')))
        w, h = size if len(size) == 2 else [-1, -1]
        if w <= 0 or h <= 0:
            raise Exception('The image size requested is incorrect. Please check it.')
            
        # Check image format
        
        
    except Exception as e:
        res["status"] = 400
        res["message"] = str(e)
        
        return {
            'statusCode': 400,
            'body': json.dumps(res)
        }
        
    try:    
        file_name = event['queryStringParameters']['img_name']
        file_name = req_time + '_' + file_name
        s3.Bucket('image-proc-practice').put_object(Body=base64.b64decode(event['body']), Key='origin/'+file_name, ACL='public-read')
        
    except Exception as e:
        res["status"] = 500
        res["message"] = 'An Error occurred while lambda was uploading image to S3.'
        return {
            'statusCode': 500,
            'body': json.dumps(res)
        }
    
    res["success"] = True
    res["message"] = 'requested'
    res["key"] = file_name.split('.')[0]+'.ply'
    
    return {
        'statusCode': 200,
        'body': json.dumps(res)
    }