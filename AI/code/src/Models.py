import torch
from torch import nn, optim
import segmentation_models_pytorch as smp


class Unet(nn.Module):
    def __init__(self, num_classes,encoder,pre_weight):
        super().__init__()
        self.model = smp.Unet( classes = num_classes,
                              encoder_name=encoder,
                              encoder_weights=pre_weight,
                              in_channels=3)
    
    def forward(self, x):
        y = self.model(x)
        encoder_weights = "imagenet"
        return y

    