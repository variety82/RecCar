import csv
import json
import os
from tqdm import tqdm

# csv header info
dic = {'img_id': 0, 'Front bumper': 1, 'Trunk lid': 2, 'Bonnet': 3, 'Head lights(L)': 4, 'Rear bumper': 5, 'Rear door(R)': 6, 'Front door(R)': 7, 'Rear fender(R)': 8, 'Rear fender(L)': 9, 'Rear lamp(R)': 10, 'Side mirror(R)': 11, 'A pillar(L)': 12, 'Rear door(L)': 13, 'Front door(L)': 14, 'Front fender(R)': 15, 'Front Wheel(L)': 16, 'Front Wheel(R)': 17, 'Rear lamp(L)': 18, 'Front fender(L)': 19, 'Rocker panel(R)': 20, 'Head lights(R)': 21, 'Rear Wheel(R)': 22, 'Rear Wheel(L)': 23, 'C pillar(L)': 24, 'Side mirror(L)': 25, 'Rocker panel(L)': 26, 'Windshield': 27, 'C pillar(R)': 28, 'Rear windshield': 29, 'Undercarriage': 30, 'Roof': 31, 'A pillar(R)': 32, 'B pillar(R)': 33, 'total_anns': 34, 'ran_var': 35, 'dataset': 36}
header = 'img_id,Front bumper,Trunk lid,Bonnet,Head lights(L),Rear bumper,Rear door(R),Front door(R),Rear fender(R),Rear fender(L),Rear lamp(R),Side mirror(R),A pillar(L),Rear door(L),Front door(L),Front fender(R),Front Wheel(L),Front Wheel(R),Rear lamp(L),Front fender(L),Rocker panel(R),Head lights(R),Rear Wheel(R),Rear Wheel(L),C pillar(L),Side mirror(L),Rocker panel(L),Windshield,C pillar(R),Rear windshield,Undercarriage,Roof,A pillar(R),B pillar(R),total_anns,ran_var,dataset'

# json Folder
path_dir = 'damage_part/'
file_list = os.listdir(path_dir)

with open('./part_labeling.csv', 'w', newline = '') as output_file:
    wr = csv.writer(output_file)
    wr.writerow(list(dic.keys()))
    
    # use limit length
    # length = 10404
    # for idx in tqdm(range(length)):
    #     file_name = file_list[idx]
    
    for idx, file_name in tqdm(enumerate(file_list)):
        with open(path_dir + file_name) as input_file:
            res = ['']*37
            data = json.load(input_file)
            anns = data['annotations']
            for ann in anns:
                parts = ann['repair']
                for repair in parts:
                    part = repair.split(':')[0]
                    if part in dic:
                        res[dic[part]] = '1'

            res[34] = str(res.count('1'))
            res[0] = file_name
            if idx % 10 == 0:
                res[36] = 'test'
            elif idx % 10 <= 7:
                res[36] = 'train'
            else:
                res[36] = 'val'
            
            wr.writerow(res)
            input_file.close()
