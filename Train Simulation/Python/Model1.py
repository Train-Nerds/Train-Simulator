import torch
import Training.ImageNormalizer
from Reward import PathAlgorithm
from Reward import RewardAlgorithm
from Reward import RewardFunction
from pathlib import Path
from torch import nn
from PIL import Image
import numpy as np
import os

def outputToImage(output) -> Image:
    outputTensor = output - output.min()  # Shift the tensor so the minimum value is 0
    outputTensor = outputTensor / outputTensor.max()  # Normalize to the range [0, 1]
    #outputTensor.cpu()

    # Apply threshold to round values to 0 or 1 and make image fully black/white
    threshold = 0.5
    outputTensor = torch.where(outputTensor < threshold, torch.tensor(1.0), torch.tensor(0.0))
    outputTensor = outputTensor * 255 # Set white pixels to be full white 

    array = outputTensor.detach().cpu().numpy().astype(np.uint8) # Tensor to array
    image = Image.fromarray(array, mode='L')  # 'L' mode is for (8-bit pixels, black and white)
    return image

class MainModel(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        # 3 input channels, one for each RGB channel
        # 32 output channels
        # Kernel size of 3 to analyze a 3x3 area
        # Stride of 1 to analyze the pixels directly next to the current one
        # Padding to maintain the same 2d shape
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, stride=1, padding=1)
        # Normalize data from Conv2d, 32 input channels
        self.bn2 = nn.BatchNorm2d(32)
        # Relu algorithm to ensure no negative values and introduce complexity through big maths
        self.relu = nn.ReLU()
        self.mp3 = nn.MaxPool2d(kernel_size=2, stride=2)
        # Upsample
        self.deconv4 = nn.ConvTranspose2d(32,1,kernel_size=2, stride=2)


    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # Pass input (x) tensor through all the layers
        # Can be called through `model(x)`

        x = self.conv1(x)
        #print(f'Conv1 shape: {x.shape}')
        x = x.unsqueeze(dim=1)
        #print(f'Unsqueezed: {x.shape}')
        x = x.permute(1,0,2,3)
        #print(f'Permuted: {x.shape}')
        x = self.bn2(x)
        #print(f'BatchNorm: {x.shape}')
        x = self.relu(x)
        #print(f'Relu: {x.shape}')
        x = self.mp3(x)
        #print(f'MaxPool: {x.shape}')
        x = self.deconv4(x)
        #print(f'Deconv: {x.shape}')
        x = x.squeeze()
        return x
    
    def trainModel(self, inputFolderPath, scedStep=10000, scedGamma=0.1, 
                   printProgress=True, printLoss=False, epochs=25, device=torch.device('cpu') ) -> None:
        # Function to train the given model

        # Optimizer to change values
        optimizer = torch.optim.Adam(self.parameters(),lr=0.001)
        # Scheduler to change learning rate
        scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=scedStep, gamma=scedGamma)
        # For each training cycle
        for epoch in range(epochs): # Each epoch is a full folder passthrough
            # Loop through all files in the directory
            for imgName in os.listdir(inputFolderPath):
                filepath = os.path.join(inputFolderPath, imgName)
                with Image.open(filepath) as image:
                    # Convert given image to tensor
                    input = Training.ImageNormalizer.imageToTensor(image).to(device)

                    self.train()
                    outputTensor = self(input)
                    outputTensor.cpu()
                    output = outputToImage(outputTensor)
                    rewardFunction = RewardFunction.Reward_Function(30000, 100) # RewardModifier, waterLevel
                    print("Initialized Reward Function")
                    loss = rewardFunction.reward_Calculator(image, output)
                    print("Rewarded 1")
                    print(loss)
                    # Avoid stacking gradients
                    optimizer.zero_grad()
                    # Backwards prop to determine how to change values
                    loss.backward()
                    # Step the optimizer and scheduler to make values more precise and avoid overshoot
                    optimizer.step()
                    scheduler.step()

            # Print progress when desired
            percent = (epoch/epochs)*100
            #if (percent % 1 == 0):
            if ( True ):
                if ( printProgress ):
                    print(f"{percent}%")
                if ( printLoss ):
                    print(f"Loss: {loss.item()}")
        
        print("Training Complete")
        return
    
    def saveModel(self, name, folderName="models") -> None:
        # Saves model in its current state, helpful to avoid unnecessary/repetitive training

        path = Path(folderName)
        path.mkdir(parents=True,exist_ok=True) # Make folder if not already there, will not error if folder is there
        name = f"{name}.pth" #.pth or PyTorch State file
        savePath = path/name
        print(f"Saving model to: {savePath}")
        torch.save(self,f=savePath)
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")
    
    def loadModel(self,modelName, folderName="models") -> None:
        # Loads a saved model as defined in saveModel

        path = Path(folderName)
        name = f"{modelName}.pth"
        loadPath = path/name
        print(f"Opening model from: {loadPath}")
        self.load_state_dict(torch.load(f=loadPath).state_dict())
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")
    