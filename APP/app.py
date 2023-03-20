from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import datetime
import inference
from service.s3_service import *
from service.video_service import *

app = FastAPI()

s3 = s3_connection()
bucket = os.getenv("bucket_name")

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

@app.post("/ai-api/v1/damage") 
async def upload_video(file : UploadFile, user_id : str):
    upload_path = "./dataset/video"
    content = await file.read()
    now = str(datetime.datetime.now()).replace(" ", "_").replace(":", "-")[:-7]

    filen_name = f"user_{user_id}_{now}.mp4"
    with open(os.path.join(upload_path, filen_name), "wb") as fp:
        fp.write(content)  # 서버 로컬 스토리지에 이미지 저장 (쓰기)

    images = video_to_image(filen_name)
    created_img = inference.create_images(images)

    obj_list = upload_s3(s3, bucket, created_img, "hero")
    images_list = get_images_url(s3, bucket, obj_list)

    return images_list

if __name__ == '__main__':
    uvicorn.run(app, host = '0.0.0.0', port=8081)