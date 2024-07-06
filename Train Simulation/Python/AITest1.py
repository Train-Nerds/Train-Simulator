import torch
import numpy as np
from PIL import Image
import Model1

# Set up devices for possible GPU accelleration
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
cpu = torch.device("cpu")

#Path = r"C:\Users\endpl\Desktop\GHP\Trainerds\Training\Unsized Training Images\heightmap.png"

# Normalize data
def outputToImage(output) -> Image:
    outputTensor = output - output.min()  # Shift the tensor so the minimum value is 0
    outputTensor = outputTensor / outputTensor.max()  # Normalize to the range [0, 1]
    outputTensor.to(cpu)

    # Apply threshold to round values to 0 or 1 and make image fully black/white
    threshold = 0.5
    outputTensor = torch.where(outputTensor < threshold, torch.tensor(1.0), torch.tensor(0.0))
    outputTensor = outputTensor * 255 # Set white pixels to be full white 

    array = outputTensor.detach().numpy().astype(np.uint8) # Tensor to array
    image = Image.fromarray(array, mode='L')  # 'L' mode is for (8-bit pixels, black and white)
    return image
    # image.save(f'Trainerds\\Training\\Completed Images\\finished1.png')

def printParams(model) -> None:
    # Print each of the model's tensor parameters
    for name, param in model.named_parameters():
                print(f"{name}: {param}")



ml = Model1.MainModel().to(device)
#printParams(ml)
ml.trainModel('C:\\Users\\endpl\\Desktop\\GHP\\Trainerds\\Training\\Training Images',printLoss=True,device=device)
ml.saveModel("TestAI1")
#printParams(ml)