import json
import os

import boto3
from botocore.exceptions import BotoCoreError, ClientError


dynamodb = boto3.client("dynamodb")
table_name = os.environ["COUNTER_TABLE_NAME"]
counter_pk = os.environ.get("COUNTER_PARTITION_KEY", "site-total")


def handler(event, context):
    try:
        response = dynamodb.update_item(
            TableName=table_name,
            Key={"pk": {"S": counter_pk}},
            UpdateExpression="SET #count = if_not_exists(#count, :start) + :inc",
            ExpressionAttributeNames={"#count": "count"},
            ExpressionAttributeValues={":start": {"N": "0"}, ":inc": {"N": "1"}},
            ReturnValues="UPDATED_NEW",
        )

        count = int(response["Attributes"]["count"]["N"])
        body = {"count": count}
        status_code = 200
    except (BotoCoreError, ClientError, KeyError, ValueError) as exc:
        body = {"error": "Unable to increment counter", "detail": str(exc)}
        status_code = 500

    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
