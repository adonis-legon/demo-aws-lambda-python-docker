import json

from src.app.my_math import sum


def handler(event, context):
    result = 0

    if event:
        event_body = json.loads(event["body"])
        result = sum(event_body["a"], event_body["b"])

    
    print(f'Result is: {result}')
    return {
        "statusCode": 200,
        "body": {
            "result": result
        }
    }