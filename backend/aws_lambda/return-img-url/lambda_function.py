import json
import boto3


def lambda_handler(event, context):
    
    client = boto3.client('s3')
    prefix_len = 15
    target = ""
    
    res = {
        "status": 200,
        "success": False,
        "message": ''
    }
    
    # Check request Content-Type
    if event["multiValueHeaders"]["Content-Type"][0] != "application/json":
        res["status"] = 400
        res["message"] = 'You should request with Content-Type application/json.'
        return {
            'statusCode': 400,
            'body': json.dumps(res)
        }
    
    # check request body.
    try:
        target = json.loads(event["body"])["key"]
    except Exception as e:
        res["status"] = 400
        res["message"] = 'Please fill the `key` in request body.'
        return {
            'statusCode': 400,
            'body': json.dumps(res)
        }
    
    # Search S3 using target key
    try:
        paginator = client.get_paginator('list_objects_v2')
        page_iterator = paginator.paginate(Bucket="image-proc-practice", Prefix="test-converted")
        
        objects = page_iterator.search("Contents[?ends_with(Key, `" + target + "`)][]")
            
    except Exception as e:
        res["status"] = 500
        res["message"] = 'An Error occurred while lambda was getting S3 object list.'
        return {
            'statusCode': 500,
            'body': json.dumps(res)
        }
    
    # Is target Key in S3?
    converted = [x for x in objects]
    if converted == []:
        res["status"] = 404
        res["message"] = 'Cannot find requested key in s3.'
        res["key"] = target
        
        return {
            'statusCode': 404,
            'body': json.dumps(res)
        }
    
    # Making pre-signed Url
    try:
        response = client.generate_presigned_url(
            'get_object',Params={'Bucket': "image-proc-practice",'Key': converted[0]["Key"]},ExpiresIn=3600
        )
        
    except Exception as e:
        res["status"] = 500
        res["message"] = 'An Error occurred while lambda was getting pre-signed url.'
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }
    
    # Success
    res["success"] = True
    res["message"] = 'Done'
    res["url"] = response
    
    return {
        'statusCode': 200,
        'body': json.dumps(res)
    }