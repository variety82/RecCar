from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from typing import List
from service.s3_service import *
from service.video_service import *
import inference
import datetime
import schema
import uvicorn
import time

app = FastAPI()

origins = [
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

labels = ['Scratch', 'Breakage', 'Crushed']

@app.on_event("startup")
def startup_event():
    global s3, bucket, models
    s3 = s3_connection()
    bucket = os.getenv("bucket_name")
    models = inference.load_model(labels)

@app.post("/ai-api/v1/damage", response_model=List[schema.InferenceImage]) 
async def upload_video(file : UploadFile, user_id : str):
    if(user_id == "RecCar" or user_id == "TAEKYUN"):
        upload_path = "./dataset/video"
        content = await file.read()
        now = str(datetime.datetime.now()).replace(" ", "_").replace(":", "-")[:-7]

        filen_name = f"user_{user_id}_{now}.mp4"
        with open(os.path.join(upload_path, filen_name), "wb") as fp:
            fp.write(content)  # 서버 로컬 스토리지에 이미지 저장 (쓰기)
        
        images = video_to_image(filen_name, 30)

        created_img = inference.create_images(models, images)

        obj_list = upload_s3(s3, bucket, created_img, "hero")
        images_list = get_images_url(s3, bucket, obj_list)

        images = [{} for _ in range(len(images_list))]

        for idx, image in enumerate(images_list):
            images[idx]['url'] = image

        return images
    else:
        images = [{}]
        images[0]['url'] = "http://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg"
        return images

@app.post("/ai-api/v1/image")
async def upload_image(file : UploadFile, user_id : str):
    
    upload_path = "./dataset/images"
    content = await file.read()
    file_name = f"{user_id}.jpg"

    with open(os.path.join(upload_path, file_name), "wb") as fp:
        fp.write(content)  # 서버 로컬 스토리지에 이미지 저장 (쓰기)

    created_img = inference.create_images(models, [file_name])

    obj_list = upload_s3(s3, bucket, created_img, "hero")
    images_list = get_images_url(s3, bucket, obj_list)

    image = {}
    image['url'] = images_list[0]

    return image

if __name__ == '__main__':
    uvicorn.run("app:app", reload = True, host = '0.0.0.0', port=8081)