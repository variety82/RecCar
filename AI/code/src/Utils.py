import os
import json
import glob
import json
import cv2
import numpy as np
import pandas as pd

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable

# data_dir 받아서 coco format 수정
class RemakeCOCOformat():
    def __init__(self, img_dir, ann_dir, data_lst=None, n_sample=None, alis=None, ratio=0.05, labeling_schme=None, task=None):
        self.base_img_path = img_dir
        self.base_label_path = ann_dir
        self.images = glob.glob(os.path.join(self.base_img_path, r"*.jpg"))
        self.annotations = glob.glob(os.path.join(self.base_label_path ,r"*.json"))
        
        self.labeling_schme = labeling_schme
        self.task = task
        
        self.img_id = 0
        self.ann_id = 0

        self.ratio = ratio
        
        if data_lst:
            self.images = [ os.path.join(self.base_img_path,f.replace('.json', '.jpg')) for f in data_lst ]
            self.annotations = [ os.path.join(self.base_label_path,f.replace('.jpg', '.json')) for f in data_lst ]
            self.train_fn = alis
            
        if n_sample:
            self.n_sample = n_sample

    def load_json(self, file_name):
        with open(file_name, "r") as f:
            ann = json.load(f)
        return ann

    def save_json(self, file, file_name):
        with open(file_name, "w") as f:
            json.dump(file, f)
          
    def rebuilding(self, d, img_lst):
        # print(f"img_list : {img_lst}")
        for i in img_lst:
            self.img_id += 1
            ann = self.load_json(i)

            ann['images']['id'] = self.img_id
            img_info = ann['images']
            ann_info = ann['annotations']
            d['images'].append(img_info)
            # print(f"ann_info : {ann_info}")
            for a in ann_info:
                if a[self.task] != '':
                    self.ann_id += 1
                    a['id'] = self.ann_id
                    a['image_id'] = self.img_id
                    if self.labeling_schme:
                        if a[self.task] in self.labeling_schme:
                            a['category_id'] = self.labeling_schme.index(a[self.task])
                        else:
                            a['category_id'] = len(self.labeling_schme)
                    segs = []
                    anns = a['segmentation'][0][0]
                    for ann in anns:
                        segs.extend(ann)
                    a['segmentation'] = [segs]
                    d['annotations'].append(a)
            # print(f"d : {d}")
        return d
            
    
    def coco_json(self):
        train = self.load_json(self.annotations[0])
        train['images'] = []
        train['annotations'] = []
                

        if self.labeling_schme:
            cates = [{"id":i+1, "name":v}for i,v in enumerate(self.labeling_schme)]
            if self.task == 'part':
                cates.append({"id":len(self.labeling_schme)+1, "name":'etc'})
            train['categories']= cates
                

        
        train_imgs = [] 

        for i in self.annotations:
            ann = self.load_json(i)
            ann_info = ann['annotations']

            if len(ann_info) != 0:
                train_imgs.append(i)
        

      
        train = self.rebuilding(train, train_imgs)
        print(len(train['images'])) 
        
        if not os.path.exists("data/datainfo"):
            os.makedirs("data/datainfo")
            
        if not os.path.exists("data/result_log"):
            os.makedirs("data/result_log")
            
        if not os.path.exists("data/weight"):
            os.makedirs("data/weight")
            
        if not os.path.exists("data/Dataset/1.원천데이터/damage"):
            os.makedirs("data/Dataset/1.원천데이터/damage")
        
        if not os.path.exists("data/Dataset/1.원천데이터/damage_part"):
            os.makedirs("data/Dataset/1.원천데이터/damage_part")
        
        if not os.path.exists("data/Dataset/2.라벨링데이터/damage"):
            os.makedirs("data/Dataset/2.라벨링데이터/damage")
        
        if not os.path.exists("data/Dataset/2.라벨링데이터/damage_part"):
            os.makedirs("data/Dataset/2.라벨링데이터/damage_part")
        print(f"self: {self.train_fn}")
        self.save_json(train, os.path.join("data/datainfo" ,self.train_fn + ".json"))
        


def label_split(data_dir):
    annotations = glob.glob(os.path.join(data_dir, r"*.json"))

    def load_json(file_name):
        with open(file_name, "r") as f:
            ann = json.load(f)
        return ann
    
    label_schme = {
    1:{"files":[],"label_info":'스크래치'},
    2:{"files":[],"label_info":'파손'},
    3:{"files":[],"label_info":'찌그러짐'},
    4:{"files":[],"label_info":'이격'},    
    }

    for ann in annotations:
        parse = load_json(ann)
        for a in parse['annotations']:
            label_schme[a['category_id']]['files'].append(ann)
    
    for i in label_schme:
        label_schme[i]['files'] = np.random.choice(list(set(label_schme[i]['files'])), 10, replace = False)
    
    for i in label_schme:
        coco = RemakeCOCOformat('rst', data_lst=label_schme[i]['files'], alis = f"_label{i}")
        coco.coco_json()

    return label_schme
        


def label_accuracy_score(hist):
    """
    Returns accuracy score evaluation result.
      - [acc]: overall accuracy
      - [acc_cls]: mean accuracy
      - [mean_iu]: mean IU
      - [fwavacc]: fwavacc
    """
    acc = np.diag(hist).sum() / hist.sum()
    with np.errstate(divide='ignore', invalid='ignore'):
        acc_cls = np.diag(hist) / hist.sum(axis=1)
    acc_cls = np.nanmean(acc_cls)

    with np.errstate(divide='ignore', invalid='ignore'):
        iu = np.diag(hist) / (hist.sum(axis=1) + hist.sum(axis=0) - np.diag(hist))
    if sum(np.isnan(iu)) == len(iu):
        mean_iu = np.mean([0,0])
    else:
        mean_iu = np.nanmean(iu)
    
    # add class iu
    cls_iu = iu
    cls_iu[np.isnan(cls_iu)] = -1
    freq = hist.sum(axis=1) / hist.sum()
    fwavacc = (freq[freq > 0] * iu[freq > 0]).sum()
    return acc, acc_cls, mean_iu, fwavacc, cls_iu





def _fast_hist(label_true, label_pred, n_class):
    mask = (label_true >= 0) & (label_true < n_class)
    hist = np.bincount(n_class * label_true[mask].astype(int) + label_pred[mask],
                        minlength=n_class ** 2).reshape(n_class, n_class)
    return hist


def add_hist(hist, label_trues, label_preds, n_class):
    """
        stack hist(confusion matrix)
    """

    for lt, lp in zip(label_trues, label_preds):
        hist += _fast_hist(lt.flatten(), lp.flatten(), n_class)

    return hist

class FocalLoss(nn.Module):
    "Non weighted version of Focal Loss"
    def __init__(self, alpha=.25, gamma=2):
        super(FocalLoss, self).__init__()
        self.alpha = torch.tensor([alpha, 1-alpha]).cuda()
        self.gamma = gamma

    def forward(self, inputs, targets):
        BCE_loss = nn.CrossEntropyLoss()(inputs, targets)
        targets = targets.type(torch.long)
        at = self.alpha.gather(0, targets.data.view(-1))
        pt = torch.exp(-BCE_loss)
        F_loss = at*(1-pt)**self.gamma * BCE_loss
        return F_loss.mean()


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--make_cocoformat',  help='make_cocoformat')
    parser.add_argument('--task', help = "all / damage / part")

    arg = parser.parse_args()

    if arg.make_cocoformat :
        if (arg.task == "all" or arg.task == "part"):
            # part
            print("make_cocoformat[part]")
            label_df = pd.read_csv('code/part_labeling.csv')

            dir_name_img = 'data/Dataset/1.원천데이터/damage_part'
            dir_name_label = 'data/Dataset/2.라벨링데이터/damage_part'
            l_sch = ["Front bumper","Rear bumper","Front fender(R)","Front fender(L)","Rear fender(R)","Trunk lid","Bonnet","Rear fender(L)","Rear door(R)","Head lights(R)","Head lights(L)","Front Wheel(R)","Front door(R)","Side mirror(R)"]
            
            ######
            # l_sch = [ "Front bumper","Rear bumper","Front fender(R)","Front fender(L)","Rear fender(R)","Trunk lid","Bonnet","Rear fender(L)",
            # "Rear door(R)","Head lights(R)","Head lights(L)","Front Wheel(R)","Front door(R)","Rocker panel(R)","Side mirror(R)",
            # "Rear door(L)","Front door(L)","Side mirror(L)","Front Wheel(L)","Rear lamp(L)","Rear lamp(R)","Rocker panel(L)",
            # "Rear Wheel(R)","Rear Wheel(L)"]
            #####

            for dt in ['train','val','test']:
                tmp = list(label_df.loc[label_df.dataset == dt]['img_id'])
                print(f"dt : {dt}")
                tmp = RemakeCOCOformat(img_dir = dir_name_img, ann_dir = dir_name_label, data_lst = tmp, alis= f'part_{dt}', ratio=0.1, labeling_schme=l_sch, task='part')
                ### dt_25cls 수정 요망
                tmp.coco_json()
            print('Done part')

        if (arg.task == "all" or arg.task == "damage"):
            # damage
            print("make_cocoformat[damage]")

            label_df = pd.read_csv('code/damage_labeling.csv')
            label_df = label_df.loc[label_df.total_anns > 0]
            print(len(label_df))

            idx = 0


            dir_name_img = 'data/Dataset/1.원천데이터/damage'
            dir_name_label = 'data/Dataset/2.라벨링데이터/damage'
            l_sch = ["Scratched","Separated","Crushed","Breakage"]

            # training_data
            for l in l_sch:
                tmp = list(label_df.loc[(label_df['dataset'] == 'train')&(label_df[l]>0)]['index'].values)
                test = RemakeCOCOformat(img_dir = dir_name_img, ann_dir = dir_name_label, data_lst = tmp, alis=f'damage_{l}_train', ratio=0., labeling_schme=l_sch, task='damage')
                test.coco_json()

            # test, val
            for dt in ['val','test']:
                tmp = list(label_df.loc[label_df['dataset']==dt]['index'].values)
                test = RemakeCOCOformat(img_dir = dir_name_img, ann_dir = dir_name_label, data_lst = tmp, alis=f'damage_{dt}', ratio=0, labeling_schme=l_sch, task='damage')
                test.coco_json()




    