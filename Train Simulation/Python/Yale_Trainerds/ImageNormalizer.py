import torch
from PIL import Image
import numpy as np

def imageToTensor(img) -> torch.Tensor:
    # Convert a 1000x1000 image's R, G, and B channels into a float tensor with values between 0 and 1

    # Check if the image size is 1000x1000
    if img.size!= (1000, 1000):
        raise ValueError("Image dimensions must be 1000x1000.")
    
    # Convert the image data to numpy arrays
    rgbData = np.array(img.convert('RGBA'))
    
    # Normalize values bteween 0 and 1 for better training accuracy
    normalizedRgbData = rgbData[:, :, :] / 255.0

    rgbTensor = torch.from_numpy(normalizedRgbData).float().permute(2,0,1) # Permute to convert to Channel, height, width format for AI
    
    return rgbTensor

def railImageToTensor(img) -> torch.Tensor:
    # Convert a 1000x1000 image's R, G, and B channels into a float tensor with values between 0 and 1

    # Check if the image size is 1000x1000
    if img.size!= (1000, 1000):
        raise ValueError("Image dimensions must be 1000x1000.")
    
    # Convert the image data to numpy arrays
    alphaData = np.array(img.convert('RGBA'))
    normalizedAlphaData = alphaData[:, :, 3] / 255.0

    alphaTensor = torch.from_numpy(normalizedAlphaData).float().permute(0,1) # Permute to convert height, width
    
    return alphaTensor

def imageToTensorFromPath(imagePath) -> torch.Tensor:
    # Run imageToTensor with a specified path
    
    # Open the image file
    img = Image.open(imagePath)
    
    rgbTensor = imageToTensor(img)
    
    return rgbTensor

def outputToImage(output: torch.Tensor, inputImage: Image, smoothing=True) -> Image:
    outputTensor = output - output.min()  # Shift the tensor so the minimum value is 0
    outputTensor = outputTensor / outputTensor.max()  # Normalize to the range [0, 1]
    outputTensor = outputTensor.to(torch.device('cpu'))  # Move tensor to CPU

    # Apply threshold to round values to 0 or 1 and make image fully black/white
    if (smoothing):
        threshold = 0.5
        outputTensor = torch.where(outputTensor < threshold, torch.tensor(0.0), torch.tensor(1.0))
        outputTensor = outputTensor * 255  # Set white pixels to be full white 

    # Detach the tensor, convert to numpy array, and cast to uint8
    alphaChannel = outputTensor.cpu().detach().numpy().astype(np.uint8)
    
    # Ensure the original image is in RGB mode
    if inputImage.mode != "RGB":
        inputImage = inputImage.convert("RGB")

    # Convert the original image to a numpy array
    originalArray = np.array(inputImage)
    finalImage = Image.fromarray(np.dstack((originalArray, alphaChannel)), mode='RGBA')

    return finalImage

#imagePath = r'C:\Users\endpl\Desktop\GHP\Trainerds\Training\Training Images\image1.png'
#trainingImage = Image.open(imagePath)
#railImageToTensor(trainingImage)