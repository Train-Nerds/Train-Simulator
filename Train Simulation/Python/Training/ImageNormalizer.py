import torch
from PIL import Image
import numpy as np

def imageToTensor(img) -> torch.Tensor:
    # Convert a 1000x1000 image's R, G, and B channels into a float tensor with values between 0 and 1

    # Check if the image size is 1000x1000
    if img.size!= (1000, 1000):
        raise ValueError("Image dimensions must be 1000x1000.")
    
    # Convert the image data to numpy arrays
    rgbData = np.array(img.convert('RGB'))
    
    # Normalize values bteween 0 and 1 for better training accuracy
    normalizedRgbData = rgbData[:, :, :] / 255.0

    rgbTensor = torch.from_numpy(normalizedRgbData).float().permute(2,0,1) # Permute to convert to Channel, height, width format for AI
    
    return rgbTensor


def imageToTensorFromPath(imagePath) -> torch.Tensor:
    # Run imageToTensor with a specified path
    
    # Open the image file
    img = Image.open(imagePath)
    
    rgbTensor = imageToTensor(img)
    
    return rgbTensor
