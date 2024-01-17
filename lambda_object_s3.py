# aws s3api get-object --bucket arn:aws:s3-........ --key ......json transformed_data.json

import boto3
import urllib3
import json

http = urllib3.PoolManager()

def lambda_handler(event, context):
    print(event)

    # Extract relevant metadata including S3URL out of input event
    object_get_context = event["getObjectContext"]
    request_route = object_get_context["outputRoute"]
    request_token = object_get_context["outputToken"]
    s3_url = object_get_context["inputS3Url"]

    # Download S3 File
    response = http.request('GET', s3_url)
    
    original_object = response.data.decode('utf-8')
    as_list = json.loads(original_object)
    result_list = []

    # Transform object
    for record in as_list:
        if record['orderType'] == "REFUND":
            result_list.append(record)

    # Write object back to S3 Object Lambda
    s3 = boto3.client('s3')
    s3.write_get_object_response(
        Body=json.dumps(result_list),
        RequestRoute=request_route,
        RequestToken=request_token)

    return {'status_code': 200}
