# -*- coding: utf-8 -*-
import torch
import numpy as np
import os
import random
import argparse
from functools import partial

from src.Models import Unet
from src.Train import Trainer
from src.Evaluation import Evaluation
from src.Utils import FocalLoss
from torch.optim.lr_scheduler import StepLR
from torch.optim.lr_scheduler import CosineAnnealingLR
import albumentations as A
from albumentations.pytorch import ToTensorV2



if __name__ == "__main__":
    ## weighted loss
    weights = torch.tensor([100,1], dtype=torch.float32)
    # weights = 1.0 / weights weight=weights.cuda()
    weights = weights / weights.sum()
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--train',  help='train')
    parser.add_argument('--eval', help='evaluation')
    parser.add_argument('--task', help='damage vs part')
    parser.add_argument('--method', help='multi : multi models, single : single model')
    parser.add_argument('--label', help="all, 2,3,4,5")
    parser.add_argument('--cls', type = int, help = "n_class")
    parser.add_argument('--dataset', help = "val vs test")
    parser.add_argument('--weight_file', help = "weight file name")
    parser.add_argument('--name')
    arg = parser.parse_args()

    
    ## model
    
    if arg.task == 'damage':
        n_cls = 2
    elif arg.eval:
        n_cls = 16
    else:
        n_cls = arg.cls
    print('gpu device num')    
    print(torch.cuda.current_device())

    model = Unet(encoder="resnet34",pre_weight='imagenet',num_classes=n_cls)
    
    ## set seed
    def set_seed(seed:int):
        random.seed(seed)
        np.random.seed(seed)
        os.environ["PYTHONHASHSEED"] = str(seed)
        torch.manual_seed(seed)
        torch.cuda.manual_seed(seed)  # type: ignore
        torch.backends.cudnn.deterministic = True  # type: ignore
        torch.backends.cudnn.benchmark = True  # type: ignore
    set_seed(1230)
    
    
    ## model load
    def load_model(model, weight_path, strict):
        device = 'cuda' if torch.cuda.is_available() else 'cpu'
        model = model.to(device)
        try:
            model.model.load_state_dict(torch.load(weight_path, map_location=torch.device(device)),strict=strict)
            return model
        except:
            model.load_state_dict(torch.load(weight_path, map_location=torch.device(device)),strict=strict)
            return model
    
    
    ## train
    if arg.train:
        # 캐시삭제
        torch.cuda.empty_cache()
        # train damage
        if (arg.label == "all") & (arg.task == "damage"):
#             label_schme = ["Crushed","Breakage"]
            label_schme = ["Scratched"]
#             label_schme = ["Crushed"]
#             label_schme = ["Breakage"]

            scheduler = partial(CosineAnnealingLR, T_max=5, eta_min=0)
            
            
            transform = A.Compose([
                            A.Resize(512, 512),
                            A.RandomBrightnessContrast(brightness_limit=(-0.3, 0.3), contrast_limit=(-0.3, 0.3), p=1),
                            A.OneOf([
                                        A.CLAHE(p=0.7),
                                        A.ToGray(p=0.3)
                                    ], p=0.5),
                            A.OneOf([
                                        A.HorizontalFlip(p=1),
                                        A.RandomRotate90(p=1),
                                        A.VerticalFlip(p=1)            
                                    ], p=0.5),
                            A.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225]),
#                             ToTensorV2()
                
                            
            ]) 
            
            for i in range(1):
                trainer = Trainer(
                            ails = f"{arg.task}",
                            wandb_name = arg.name,
                            train_dir = f"../data/datainfo/{arg.task}_{label_schme[i]}_train.json",
                            val_dir = f"../data/datainfo/{arg.task}_val.json",
                            img_base_path = '../data/Dataset/1.원천데이터/damage',
                            size = 512,
                            model = model,
                            label = label_schme[i],
                            n_class = n_cls,
                            optimizer = torch.optim.AdamW,
                            lr_scheduler = scheduler,
                            criterion = torch.nn.CrossEntropyLoss(),
                            epochs = 30,
                            batch_size = 256,
                            encoder_lr = 1e-06,
                            decoder_lr = 3e-04,
                            weight_decay = 0,
                            transform = transform,
                            device = "cuda")
                trainer.train()
        # train damage one label
        elif (arg.task == 'damage') & (arg.method == 'multi'):
            trainer = Trainer(
                        ails = f"{arg.task}_label{arg.label}",
                        train_dir = f"../data/datainfo/{arg.task}_trainsample.json",
                        val_dir = f"../data/datainfo/{arg.task}_valsample.json",
                        img_base_path = '../data/Dataset/1.원천데이터/damage_part',
                        size = 256,
                        model = model,
                        label = arg.label,
                        n_class = n_cls,
                        optimizer = torch.optim.AdamW,
                        criterion = torch.nn.CrossEntropyLoss(),
                        epochs = 70,
                        batch_size = 2,
                        encoder_lr = 1e-07,
                        decoder_lr = 1e-06,
                        weight_decay = 0,
                        device = "cuda")
            trainer.train()
        
        # train part_ver2
        else:

            transform = A.Compose([
                            A.RandomRotate90(p=0.3),
                            A.Cutout(p=0.3,max_h_size=32,max_w_size=32),
                            A.Resize(256,256)])       

            scheduler = partial(StepLR, step_size=10, gamma=0.9)
            trainer = Trainer(
                ails = f"{arg.task}",
                train_dir = f"../data/datainfo/{arg.task}_train.json",
                val_dir = f"../data/datainfo/{arg.task}_val.json",
                img_base_path = '../data/Dataset/1.원천데이터/damage_part',
                size = 256,
                model = model,
                label = None,
                n_class = arg.cls,
                optimizer = torch.optim.AdamW,
                criterion = torch.nn.CrossEntropyLoss(),
                epochs = 57,
                batch_size = 2,
                encoder_lr = 1e-06,
                decoder_lr = 3e-04,
                weight_decay = 1e-02,
                device = "cuda",
                transform = transform,
                lr_scheduler = scheduler,
                start_epoch = None)
            trainer.train()
            
    
    if arg.eval:
        set_seed(12)
        # evaluation
        if arg.task == 'damage':
            evaluation = Evaluation(
                        eval_dir = f"../data/datainfo/damage_{arg.dataset}.json",
                        size = 512, 
                        model = model, 
                        weight_paths = ["../data/weight/"+n for n in ["[DAMAGE][Scratch_0]Unet.pt","[DAMAGE][Seperated_1]Unet.pt","[DAMAGE][Crushed_2]Unet.pt","[DAMAGE][Breakage_3]Unet.pt"]],
                        device = 'cuda',
                        batch_size = 256, 
                        ails = f"../data/result_log/[{arg.task}]_{arg.dataset}_evaluation_log.json",
                        criterion = torch.nn.CrossEntropyLoss(),
                        img_base_path = "../data/Dataset/1.원천데이터/damage"
            )
            evaluation.evaluation()
        else:
            model = Unet(encoder="resnet34",pre_weight='imagenet',num_classes=n_cls)
            if arg.weight_file:
                weight_path = f"../data/weight/{arg.weight_file}"
            else:
                weight_path = "../data/weight/[PART]Unet.pt"
            evaluation = Evaluation(
                        eval_dir = f"../data/datainfo/part_{arg.dataset}.json",
                        size = 64, 
                        model = model, 
                        weight_paths = [weight_path],
                        device = 'cuda',
                        batch_size = 2, 
                        ails = f"../data/result_log/[{arg.task}]_{arg.dataset}_evaluation_log.json",
                        criterion = torch.nn.CrossEntropyLoss(),
                        img_base_path = "../data/Dataset/1.원천데이터/damage_part"
            )
            evaluation.evaluation()

