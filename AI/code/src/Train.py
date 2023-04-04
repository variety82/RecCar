import datetime
import os
import random
from pytz import timezone
import json
import wandb
import time

import torch
import torch.nn as nn

from torch.optim import Adam
import cv2
import numpy as np

import src.Models as models
from src.Datasets import Datasets
from src.Utils import label_accuracy_score,add_hist
from torch.utils.data import DataLoader
from tqdm import tqdm

class Trainer():
    def __init__(self, wandb_name,
                train_dir, val_dir, size, label,
                model, n_class, criterion, optimizer, device,
                epochs, batch_size, encoder_lr, decoder_lr, weight_decay, ails, img_base_path=None, transform=None, lr_scheduler=None, start_epoch=None ):
        #wandb 실험이름
        self.wandb_name = wandb_name
        self.model = model.model
        self.n_class = n_class
        self.epochs = epochs
        self.batch_size = batch_size
        
        self.label = label
        self.one_channel = False if label is None else True
        self.train_dataset = Datasets(train_dir, 'train', size = size, label = label, one_channel = self.one_channel, img_base_path=img_base_path, transform=transform)
        self.val_dataset = Datasets(val_dir, 'train', size = size, label = label, one_channel = self.one_channel, img_base_path=img_base_path)
        
        # img_id = np.random.choice(self.val_dataset.img_ids, int(len(self.val_dataset)*0.003), replace = False)
        # self.sample_val_id = [f['file_name'] for f in self.val_dataset.coco.loadImgs(img_id)]

        self.device = device
        self.criterion = criterion

        self.optimizer = optimizer([
                                    {'params': self.model.encoder.parameters()},
                                    {'params': self.model.decoder.parameters(), 'lr':decoder_lr}
                                    ], lr = encoder_lr, weight_decay = weight_decay)
        
        if lr_scheduler:
            self.lr_scheduler = lr_scheduler(optimizer=self.optimizer)
        else:
            self.lr_scheduler = False
        
            
        
        self.ails = ails
        
        if self.one_channel:
            self.log = {
                    "comand" : "python main.py --train train --task damage --label all",
                    "start_at_kst": 1,
                    "end_at_kst": 1,
                    "train_log": []
                }
        else:
            categories = {0:{'id':0, 'name':'Background'}}
            categories.update(self.train_dataset.coco.cats)
            self.log = {
                        "comand" : "python main.py --train train --task part --cls 16",
                        "start_at_kst": 1,
                        "end_at_kst": 1,
                        "train_log": [],
                        "category" : categories
                    }

        self.logging_step = 0
        
        if start_epoch:
            self.start_epoch = start_epoch
        else:
            self.start_epoch = 0

    def get_dataloader(self):
        def collate_fn(batch):
            return tuple(zip(*batch))
        
        train_loader = DataLoader(
            dataset = self.train_dataset,
            shuffle = True, 
            num_workers = 4 * torch.cuda.device_count(),
            pin_memory=True,
            collate_fn = collate_fn,
            batch_size = self.batch_size)
            
        val_loader = DataLoader(
            dataset = self.val_dataset,
            shuffle = False, 
            num_workers = 4 * torch.cuda.device_count(),
            pin_memory=True,
            collate_fn = collate_fn,
            batch_size = self.batch_size)

        
        return train_loader, val_loader

    
    def train(self):
        print(f'--- start-training ---')
        now = datetime.datetime.now(timezone('Asia/Seoul'))
        start_time = now.strftime('%Y-%m-%d %H:%M:%S %Z%z')
        self.log['start_at_kst'] = start_time
        
        # wandb init
        wandb.init(name = f'{self.wandb_name}',project="heroes_car", entity="heroes_pjt")
        train_data_loader, self.val_data_loader = self.get_dataloader()
        # multi gpu
        n_gpus = torch.cuda.device_count()
        print(f"n_gpus : {n_gpus}")
        
        os.environ['CUDA_LAUNCH_BLOCKING'] = "1"
        os.environ["CUDA_VISIBLE_DEVICES"] = "0"
        
        
        self.model = nn.DataParallel(self.model, device_ids = [0, 1, 2, 3]).to(self.device)
#         self.model.to(self.device)
        
        best_loss = 999999999
        best_mIoU = 0.0
        for epoch in range(self.epochs):
            epoch += self.start_epoch
            print(f"epoch : {epoch+1}")    
            self.model.train()

            # loging
            train_losses = []

            for step, (images, masks, _) in enumerate(tqdm(train_data_loader)):
#                 print(f"images type {type(images[0])}")
#                 images = np.array(images)
#                 masks = np.array(masks)
                # np array -> tensor
                images = torch.tensor(images).float().to(self.device)
                masks = torch.tensor(masks).long().to(self.device)
        
                # outputs
                outputs = self.model(images)
                
                # carculate loss
                loss = self.criterion(outputs, masks)

                # backprob
                self.optimizer.zero_grad()
                loss.backward()
                self.optimizer.step()
                
                
                # loging
                if step % 100 == 0:
                    print(f"{step} step : {loss.item()}")
                    train_losses.append(loss.item())
            
            # lr_scheduler
            if self.lr_scheduler:
                self.lr_scheduler.step()

            # if epoch % 2 == 0:
                
            #logging
            base_form = {
                        "epoch": epoch+1,
                        "train_loss": [],
                        "eval": {
                            "img": [],
                            "summary": {
                                "Imou": 0.4,
                                "Average Loss": 0.2,
                                "background IoU": 0.9,
                                "target IoU": 0.3,
                                "end_at_kst" : 0
                            }
                        }
                    }
            self.log['train_log'].append(base_form)
            self.log["train_log"][self.logging_step]['train_loss'] = train_losses

            
            avrg_loss, mIoU, cls_IoU= self.validation(epoch, step, self.val_data_loader)
            if(epoch == 0):
                print(cls_IoU)
                
            wandb.log({
                    "mIoU": mIoU,
                    "avrg_loss" : avrg_loss})
                    
            print(f"now_time : {time.strftime('%Y-%m-%d %H:%M:%S')}")
            self.logging_step += 1
            
            #early stopping
            stop_cnt = 0
            
            if (best_mIoU < mIoU):
                if self.one_channel:
                    print("one_channel")
                    save_file_name = f"../data/weight/{self.ails}_label{self.label}_start:{start_time}_{epoch+1}_epoch_IoU_{float(mIoU):.1}"
                    save_log_name = f"../data/result_log/[{self.ails}_label{self.label}]train_log.json"
                else:
                    save_file_name = f"../data/weight/Unet_{self.ails}_start:{start_time}_{epoch+1}_epoch_IoU_{float(mIoU):.1}"
                    save_log_name = f"../data/result_log/[{self.ails}]train_log.json"
                self.save_model(save_file_name)
                best_mIoU = mIoU
                stop_cnt = 0
            else:
                stop_cnt +=1
                
            if(stop_cnt == 6):
                print(f"early stooping! stop_cnt : {stop_cnt}")
                break




    def save_model(self, file_name):
        # check_point = {'net': self.model.state_dict()}
        file_name = file_name + '.pt'
        # output_path = os.path.join('weigth', file_name)
        #torch.save(self.model.state_dict(), file_name)
        
        ## model save
        if isinstance(self.model, nn.DataParallel): ## 다중 GPU를 사용한다면
            torch.save(self.model.module.state_dict(), file_name) ## model.module 형태로 module.을 제거하고 저장
        else:
            torch.save(self.model.state_dict(), file_name)  ## 일반저장
        print('MODEL SAVED!!')

    def validation(self, epoch, step, data_loader):
        n_class = self.n_class
        print('Start validation # epoch {} # step {}'.format(epoch,step))
        self.model.eval()

        with torch.no_grad():
            total_loss = 0
            cnt = 0
            hist = np.zeros((n_class, n_class))

            mIoU_list = []
            for step, (images, masks, img_ids) in tqdm(enumerate(data_loader)):
                images = torch.tensor(images).float().to(self.device)
                masks = torch.tensor(masks).long().to(self.device)


                outputs = self.model(images)
                loss = self.criterion(outputs, masks)
                total_loss += loss
                cnt += 1
                
                # output postprocessing
                outputs = torch.argmax(outputs, dim=1).detach().cpu().numpy()
                masks = masks.detach().cpu().numpy()
                
                
                for i, img_id in enumerate(img_ids):
                    
                    h = np.zeros((n_class, n_class))
                    
                    h += add_hist(h, masks[i], outputs[i], n_class=n_class)
                    acc, acc_cls, mIoU, fwavacc, cls_IoU = label_accuracy_score(h)
                    
                    tmp = {"img_id": img_id,
                            "IoU" : list(cls_IoU)}
                    # sample_logging
                    self.log["train_log"][self.logging_step]['eval']['img'].append(tmp)
                    

                hist += add_hist(hist, masks, outputs, n_class=n_class)

            
            acc, acc_cls, mIoU, fwavacc, cls_IoU = label_accuracy_score(hist)
            avrg_loss = total_loss / cnt
         
            
            if self.one_channel:
                # logging
                now = datetime.datetime.now(timezone('Asia/Seoul'))
                end_time = now.strftime('%Y-%m-%d %H:%M:%S %Z%z')
                tmp = {"mIoU": mIoU.item(),
                        "average Loss" : avrg_loss.item(), 
                        "background IoU" : cls_IoU[0].item(),
                        "target IoU" : cls_IoU[1].item(),
                        "end_at_kst" : end_time}
                
                self.log["end_at_kst"] = end_time
                self.log["train_log"][self.logging_step]['eval']['summary'] = tmp

                message='Validation #{} #{} Average Loss: {:.4f}, mIoU: {:.4f}, background IoU : {:.4f}, target IoU : {:.4f}'.format(epoch, step, avrg_loss, mIoU, cls_IoU[0], cls_IoU[1] )
            else:
                message='Validation #{} #{} Average Loss: {:.4f}, mIoU: {:.4f}, background IoU : {:.4f}, target 1IoU : {:.4f}, target 2IoU : {:.4f}, target 3IoU : {:.4f}, target 3IoU : {:.4f}'.format(epoch, step, avrg_loss, mIoU, cls_IoU[0], cls_IoU[1], cls_IoU[2], cls_IoU[3], cls_IoU[4] )
                now = datetime.datetime.now(timezone('Asia/Seoul'))
                end_time = now.strftime('%Y-%m-%d %H:%M:%S %Z%z')
                tmp = {"mIoU": mIoU.item(),
                        "average Loss" : avrg_loss.item(), 
                        "background IoU" : cls_IoU[0].item(),
                        "target IoU" : list(cls_IoU[1:]),
                        "end_at_kst" : end_time}
                
                self.log["end_at_kst"] = end_time
                self.log["train_log"][self.logging_step]['eval']['summary'] = tmp

            print(message)
            
            if self.one_channel:
                save_log_name = f"../data/result_log/[{self.ails}_label{self.label}]train_log.json"
            else:
                save_log_name = f"../data/result_log/[{self.ails}]train_log.json"

            with open( f"{save_log_name}", "w" ) as f:
                json.dump(self.log,f)

        return avrg_loss, mIoU, cls_IoU