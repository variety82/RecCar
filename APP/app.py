from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import datetime
import inference
from service.s3_service import *
from service.video_service import *
import time

app = FastAPI()

# s3 = s3_connection()
# bucket = os.getenv("bucket_name")

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


@app.on_event("startup")
def startup_event():
    global s3, bucket, model
    s3 = s3_connection()
    bucket = os.getenv("bucket_name")
    model = inference.load_model()

@app.post("/ai-api/v1/damage") 
async def upload_video(file : UploadFile, user_id : str):
    before = time.time()
    upload_path = "./dataset/video"
    content = await file.read()
    now = str(datetime.datetime.now()).replace(" ", "_").replace(":", "-")[:-7]
    # 비디오 to 이미지
    vidoe_to_image_before = time.time()

    filen_name = f"user_{user_id}_{now}.mp4"
    with open(os.path.join(upload_path, filen_name), "wb") as fp:
        fp.write(content)  # 서버 로컬 스토리지에 이미지 저장 (쓰기)

    images = video_to_image(filen_name)
    vidoe_to_image_after = time.time()

    # print(f"video_to_image : {vidoe_to_image_after - vidoe_to_image_before}")

    # print(f"create_images : {images}")

    inference_before = time.time()
    created_img = inference.create_images(model, images)
    inference_after = time.time()

    print(f"inference time : {inference_after - inference_before}")

    s3_before = time.time()
    obj_list = upload_s3(s3, bucket, created_img, "hero")
    # print(f"created_img : {created_img}")
    images_list = get_images_url(s3, bucket, obj_list)
    s3_after = time.time()

    # print(f"s3 time : {s3_after - s3_before}")

    after = time.time()
    # print(f"total time : {after - before}")

    return images_list

if __name__ == '__main__':
    uvicorn.run("app:app", reload = True, host = '0.0.0.0', port=8081)