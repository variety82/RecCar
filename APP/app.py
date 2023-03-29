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

labels = ['Scratch_0', 'Breakage_3', 'Crushed_2']

@app.on_event("startup")
def startup_event():
    global s3, bucket, models
    s3 = s3_connection()
    bucket = os.getenv("bucket_name")
    models = inference.load_model(labels)

@app.post("/ai-api/v1/damage") 
async def upload_video(file : UploadFile, user_id : str, response_model=schema.Inference_image):
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
        images[idx]['damage'] = labels[idx % 3]

    return images

if __name__ == '__main__':
    uvicorn.run("app:app", reload = True, host = '0.0.0.0', port=8081)