from pydantic import BaseModel

class Inference_image(BaseModel):
    url : str
    damage : str