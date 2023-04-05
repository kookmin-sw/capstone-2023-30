import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3')
s3_resource = boto3.resource('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    converted = key.split('/')[1]
    converted = converted.split('.')[0] + '.ply'
    
    try:
        s3_resource.Bucket('image-proc-practice').put_object(Body='dummy test', Key='test-converted/'+ converted, ACL='public-read')
        return converted
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
              