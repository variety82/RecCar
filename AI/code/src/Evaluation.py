import datetime
import os
from pytz import timezone
import json
import tqdm

import torch
from torch.optim import Adam
import cv2
import numpy as np

import src.Models as models
from src.Datasets import Datasets
from src.Utils import label_accuracy_score,add_hist
from torch.utils.data import DataLoader



class Evaluation():
    def __init__(self, 
                eval_dir, size,
                model, weight_paths, device,
                batch_size, ails, criterion, img_base_path ):
        
        self.batch_size = batch_size
        self.model = model
        self.device = device
        self.ails = ails
        self.weight_paths = weight_paths
        self.eval_dir = eval_dir
        self.size = size
        self.criterion = criterion
        self.img_base_path = img_base_path

        if len(self.weight_paths) > 1:
            self.multi_model = True
            self.one_channel = True
            self.n_class = 2
            self.log = {
                        "comand" : "python main.py --eval y --task damage --dataset ",
                        "start_at_kst": 1,
                        "end_at_kst": 1,
                        "evaluation": []
                    }
        else:
            self.multi_model = False
            self.one_channel = False
            self.n_class = 16
            self.log = {
                        "comand" : "python main.py --eval y --task part --dataset ",
                        "start_at_kst": 1,
                        "end_at_kst": 1,
                        "evaluation": []
                    }
            

        self.logging_step = 0
        

    def get_dataloader(self, dataset):
        def collate_fn(batch):
            return tuple(zip(*batch))
        
        eval_loader = DataLoader(
            dataset = dataset,
            shuffle = False, 
            num_workers = 4,
            collate_fn = collate_fn,
            batch_size = self.batch_size)
            
        
        return eval_loader

    

    def evaluation(self):
        now = datetime.datetime.now(timezone('Asia/Seoul'))
        stat_time = now.strftime('%Y-%m-%d %H:%M:%S %Z%z')
        self.log['start_at_kst'] = stat_time

        if self.multi_model:
            labels = ["Scratched","Separated","Crushed","Breakage"]
            for label, weight_path in enumerate(self.weight_paths):
                print(f'start_validation damage {labels[label]}')
                self.label = label

                base_form = {
                                "label": labels[label],
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
                self.log['evaluation'].append(base_form)
                
                model = self.load_model(self.model, weight_path)

                eval_datasets = Datasets(self.eval_dir, 'train', size = self.size, label = self.label, one_channel = True, img_base_path = self.img_base_path )
                self.log['category'] = eval_datasets.coco.cats
                eval_data_loader = self.get_dataloader(eval_datasets)

                
                avrg_loss, mIoU, cls_IoU= self.validation(model, label, 0, eval_data_loader)

                with open( self.ails, "w" ) as f:
                    json.dump(self.log,f)
                
                
                torch.cuda.empty_cache()
                del eval_data_loader, eval_datasets
        else:
            print('start_validation part')
            base_form = {
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
            self.log['evaluation'].append(base_form)
            model = self.load_model(self.model, self.weight_paths[0])

            eval_datasets = Datasets(self.eval_dir, 'train', size = self.size, label = None, one_channel = False, img_base_path = self.img_base_path )
            self.log['category'] = eval_datasets.coco.cats
            eval_data_loader = self.get_dataloader(eval_datasets)


            avrg_loss, mIoU, cls_IoU= self.validation(model, 0, 0, eval_data_loader)

            with open( self.ails, "w" ) as f:
                json.dump(self.log,f)


            torch.cuda.empty_cache()
            


        now = datetime.datetime.now(timezone('Asia/Seoul'))
        end_time = now.strftime('%Y-%m-%d %H:%M:%S %Z%z')
        self.log['end_at_kst'] = end_time


    def load_model(self, model, weight_path):
        model = model.to(self.device)
        try:
            model.model.load_state_dict(torch.load(weight_path, map_location=torch.device('cuda')))
            return model.model
        except:
            model.load_state_dict(torch.load(weight_path, map_location=torch.device('cuda')))
            return model
                 

    def validation(self, model, epoch, step, data_loader):
        n_class = self.n_class
        # print('Start validation # epoch {} # step {}'.format(epoch,step))
        model.eval()

        with torch.no_grad():
            total_loss = 0
            cnt = 0
            hist = np.zeros((n_class, n_class))

            mIoU_list = []
            for step, (images, masks, img_ids) in tqdm.tqdm(enumerate(data_loader)):
                images = torch.tensor(images).float().to(self.device)
                masks = torch.tensor(masks).long().to(self.device)


                outputs = model(images)
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
                    self.log["evaluation"][epoch]['eval']['img'].append(tmp)
                      

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
                self.log["evaluation"][epoch]['eval']['summary'] = tmp

                message='Validation_label #{} #{} Average Loss: {:.4f}, mIoU: {:.4f}, background IoU : {:.4f}, target IoU : {:.4f}'.format(epoch+2, step, avrg_loss, mIoU, cls_IoU[0], cls_IoU[1] )
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
                self.log["evaluation"][self.logging_step]['eval']['summary'] = tmp
            print(message)
            
        

        return avrg_loss, mIoU, cls_IoU