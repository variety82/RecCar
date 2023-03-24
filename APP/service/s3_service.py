import boto3
import logging
import os
from botocore.exceptions import ClientError
from dotenv import load_dotenv

load_dotenv()

def s3_connection():
    try:
        s3 = boto3.client(
            service_name="s3",
            region_name = os.getenv("region"),
            aws_access_key_id = os.getenv("aws_access_key_id"),
            aws_secret_access_key = os.getenv("aws_secret_access_key")
        )
    except Exception as e:
        print(e)
    else:
        print("s3 bucket connected!")
        return s3

def make_object(bucketname, objectname):
    """
    해당 이름을 가진 오브젝트를 리턴
    """
    s3_resource = boto3.resource(
                    service_name = "s3",
                    region_name = os.getenv("region"), 
                    aws_access_key_id = os.getenv("aws_access_key_id"),
                    aws_secret_access_key = os.getenv("aws_secret_access_key")
                    )
    bucket = s3_resource.Bucket(bucketname)
    return bucket.Object(objectname)

def get_object_url(s3, object):
    filename = object.key
    bucketname = object.bucket_name
    location = s3.get_bucket_location(Bucket=bucketname)["LocationConstraint"]

    return f"https://{bucketname}.s3.{location}.amazonaws.com/{filename}"

def upload_file(s3, file_name, bucket, object_name=None):
    if object_name is None:
        object_name = os.path.basename(file_name)

    # Upload the file
    content_Type = 'jpg'
    try:
        if 'jpg' in file_name:
            content_Type = 'jpg'
        response = s3.upload_file(
            file_name,
            bucket,
            object_name,
            ExtraArgs={"ContentType": content_Type}
            )
    except ClientError as e:
        logging.error(e)
        return False
    return True

def upload_s3(s3, bucket, created_img, user_id):
    obj_list = []
    print(f"created_img : {created_img}")
    for img in created_img:
        upload_file(s3, f"./dataset/output_images/{img}", bucket, f"{user_id}/{img}")
        obj_list.append(f"{user_id}/{img}")
    return obj_list


def get_images_url(s3, bucket, obj_list):
    images_list = []
    for obj in obj_list:
        obj = make_object(bucket, obj)
        obj_url = get_object_url(s3, obj)
        images_list.append(obj_url)
    return images_list
