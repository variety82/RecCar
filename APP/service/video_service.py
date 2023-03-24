import cv2

def video_to_image(file_name, frame):
    images = []
    # 동영상 주소
    VideoPath = f'./dataset/video/{file_name}'
    # 사진 저장할 주소
    savepath = './dataset/images'
    cap = cv2.VideoCapture(f"{VideoPath}")
    idx = 0
    while True:
        idx += 1
        cap.set(cv2.CAP_PROP_POS_FRAMES, idx * frame)
        ok, image = cap.read()
        if not ok:
            break
        file = f"{file_name[:-4]}_{idx}.jpg"
        output = f"{savepath}/{file}"
        
        cv2.imwrite(output, image)
        images.append(file)

    return images
