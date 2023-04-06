import time
import torch 
import cv2
import os
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np
import asyncio
from collections import OrderedDict
from src.Models import Unet
from Utils.convert_color import *

device = 'cuda' if torch.cuda.is_available() else 'cpu'
n_classes = 2

def load_model(labels):
    models = []
    for label in labels:

        weight_path = f'./models/[DAMAGE][{label}].pt'
        #Load pretrained model
        model = Unet(encoder='resnet34', pre_weight='imagenet', num_classes=n_classes).to(device)

        loaded_state_dict = torch.load(weight_path, map_location=torch.device(device))
        new_state_dict = OrderedDict()
        for n, v in loaded_state_dict.items():
            name = n.replace("module.","") # .module이 중간에 포함된 형태라면 (".module","")로 치환
            new_state_dict[name] = v
        model.model.load_state_dict(new_state_dict)
        model.eval()
        models.append(model)
    print(f"models loaded")
    return models

def load_img(img_name):
    #org_img : 원본이미지
    #img_img : 인퍼런스하기 위해 정규화 및 RGB변경
    img_path = f"./dataset/images/{img_name}"
    org_img  = cv2.imread(img_path)
    org_img = cv2.cvtColor(org_img, cv2.COLOR_BGR2RGB)
    org_img = cv2.resize(org_img, (512, 512))

    img_input = org_img / 255.
    img_input = img_input.transpose([2, 0, 1])

    img_input = torch.tensor(img_input).float().to(device)
    img_input = img_input.unsqueeze(0)

    return org_img, img_input


def save_image(org_img, img_output, output_name):
    fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(16, 10))
    ax[0].imshow(org_img)
    ax[0].axis('off')

    ax[1].imshow(org_img.astype('uint8'), alpha=0.9)
    ax[1].imshow(img_output, alpha=0.5)
    ax[1].axis('off')
    fig.set_tight_layout(True)

    if not os.path.exists("./dataset/output_images"):
            os.makedirs("./dataset/output_images")

    plt.savefig(f'./dataset/output_images/{output_name}', dpi=50)
    plt.cla()
    plt.clf()
    plt.close()
    return output_name

def inference_img(model, img_input):
    output = model(img_input)
    output = torch.argmax(output, dim=1).detach().cpu().numpy()
    output = output.transpose([1, 2, 0])
    return output

def convert_color(convert_fn, input):
    output = np.array(input, dtype=np.uint8)
    output = cv2.cvtColor(output, cv2.COLOR_GRAY2BGR)
    return convert_fn(output)

def create_images(models, images):
    created_images = []
    colors = [convert_to_pink, convert_to_blue, convert_to_black]
    for img in images:
        org_img, img_input = load_img(img)
        gray_to_color = []
        for idx, model in enumerate(models):
            output_img = inference_img(model, img_input)

            output_img = convert_color(colors[idx], output_img)
            gray_to_color.append(output_img)
        convert_img = cv2.add(gray_to_color[0], gray_to_color[1])
        convert_img = cv2.add(convert_img, gray_to_color[2])
        created_images.append(save_image(org_img, convert_img, f"{img}"))
    return created_images