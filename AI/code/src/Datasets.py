


### lib import
import os
import glob
from torch.utils.data import Dataset
import torch
import cv2

import numpy as np
from pycocotools.coco import COCO
import albumentations as A

# ##


class Datasets(Dataset):
    def __init__(self, data_dir, mode, size, one_channel=False, transform=None, label=None, img_base_path=None):
        super().__init__()
        self.data_dir = data_dir
        self.mode = mode
        self.coco = COCO(data_dir)
        self.transform = transform
        self.one_channel = one_channel
        self.img_base_path = img_base_path if img_base_path else 'rst'
        
        
        if mode in ('train','test'):
            self.img_ids = self.coco.getImgIds()
        else:
            self.img_ids = np.random.choice(self.coco.getImgIds(), 300, replace = False)
        if label is not None:
            self.label = label
        
        self.size = size
        if self.size:
            self.resize = A.Compose([A.Resize(width=self.size, height=self.size)])
        

    
    def __getitem__(self, index: int):
        image_id = int(self.img_ids[index])
        image_infos = self.coco.loadImgs(image_id)[0]

        # load image
        images = cv2.imread(os.path.join(self.img_base_path, image_infos['file_name']))
        images = cv2.cvtColor(images, cv2.COLOR_BGR2RGB) # w * h * c


        # load label
        if self.mode in ("train","val"):
            ann_ids = self.coco.getAnnIds(imgIds=image_infos['id'])
            anns = self.coco.loadAnns(ann_ids)

            masks = np.zeros((image_infos["height"], image_infos["width"]))
            
            if self.one_channel: 
                for ann in anns:
                    if ann['category_id'] == self.label:
                        masks = np.maximum(self.coco.annToMask(ann), masks)
                masks = masks.astype(np.float32)
            else: 
                for ann in anns:
                    pixel_value = ann['category_id'] + 1
                    masks = np.maximum(self.coco.annToMask(ann) * pixel_value, masks)
                
                # masks[0][masks.sum(axis=0) == 0] = 1
                # masks = masks.astype(np.float32) # n_cls * w * h

        # transform 
        if self.transform is not None: 
            transformed = self.transform(image=images, mask=masks)
            images = transformed["image"]
            masks = transformed["mask"]
            
        elif self.size:
            if self.one_channel:
                transformed = self.resize(image=images, mask=masks)
                masks = transformed["mask"]
            else:
                # masks = masks.transpose([1,2,0]) # w * h * n_cls
                transformed = self.resize(image=images, mask=masks)
                masks = transformed["mask"]
            images = transformed["image"]
        
        
        images = images/255.
        images = images.transpose([2,0,1]) 
        
        return images, masks, image_infos['file_name']



    def __len__(self) -> int:
        return len(self.img_ids)
