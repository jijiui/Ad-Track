from __future__ import print_function
import json
import boto3
import time
from boto3 import dynamodb
from boto3.session import Session
from boto3.dynamodb.conditions import Key, Attr
from botocore.exceptions import ClientError
from decimal import *
import urllib

# Why the Primary Key is "Date & Time" and range key is "M-Phone ID"? Beacause the rule is that if these two keys of two items are the same, one of them will be deleted
print('Loading function')


def lambda_handler(event, context):
    # TODO implement
    if 'tableName' in event:
        dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    with dynamo.batch_writer() as batch:
        for i in event['payload']:
            batch.put_item(
                Item={
                    'Date & Time': event['payload'][i]['Date & Time'],
                    'Mobile Phone ID': event['payload'][i]['Mobile Phone ID'],
                    'Advertisement Board ID': event['payload'][i]['Advertisement Board ID'],
                    'City': event['payload'][i]['City']

                }
            )

    return event['payload']["0"]