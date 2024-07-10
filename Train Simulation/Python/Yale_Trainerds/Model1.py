import torch

from Python.Yale_Trainerds import ImageNormalizer
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
        self.conv1 = nn.Conv2d(4, 32, kernel_size=3, stride=1, padding=1)
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
    
    def generateAlphaChannel(self, inputImage: Image) -> Image:
        self.eval()
        trainingTensor = ImageNormalizer.imageToTensor(inputImage)
        outputTensor = self(trainingTensor)
        outputImage = ImageNormalizer.outputToImage(outputTensor,inputImage,smoothing=True)
        return outputImage

    def trainModel(self, inputFolderPath, learningRate=0.1,scedStep=10000, scedGamma=0.1, 
                   printProgress=True, printLoss=False, epochs=100000, device=torch.device('cpu'), saveModel=False ) -> None:
        # Define loss function, optimizer, and scheduler
        loss_fn = nn.BCEWithLogitsLoss() 
        optimizer = torch.optim.Adam(self.parameters(),lr=learningRate)
        #scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer,mode='min', factor=scedGamma, patience=scedStep, verbose=verboseSced)
        scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=scedStep, gamma=scedGamma)

        # For each training cycle
        for epoch in range(epochs): # Each epoch is a full folder passthrough

            loss = 0
            # Loop through all files in the directory
            for imgName in os.listdir(inputFolderPath):
                # Define file paths for input and ideal images
                filepath = os.path.join(inputFolderPath, imgName)
                #filePath2 = os.path.join(trainingFolderPath,imgName)

                # Open the images as a PIL Image object
                image = Image.open(filepath)
                #train = Image.open(filePath2)

                # Convert given images to tensors
                input = ImageNormalizer.imageToTensor(image).to(device)
                idealTensor = ImageNormalizer.railImageToTensor(image).to(device)

                # Set model to training mode
                self.train()

                # Pass through model
                outputTensor = self(input)

                # Calculate loss
                loss = loss_fn(outputTensor,idealTensor)

                # Avoid stacking gradients
                optimizer.zero_grad()

                # Backwards prop to determine how to change values
                loss.backward()

                # Step the optimizer and scheduler to make values more precise and avoid overshoot
                optimizer.step()
                scheduler.step()

            # Print progress when desired
            percent = (epoch/epochs)*100
            if (percent % 1 == 0):
                if ( printProgress ):
                    print(f"{percent}%")
                if ( printLoss ):
                    print(f"Loss: {loss.item()}")
                if ( saveModel ):
                    self.saveModel("TrainedModel1")
                    # Save model twice to avoid a save being interupted
                    self.saveModel("TrainedModelBackup")
                    print("Saved model")
        
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
    
    def loadModel(self, modelName, folderName="models", device=torch.device("cpu")) -> None:
        # Loads a saved model as defined in saveModel

        path = Path(folderName)
        name = f"{modelName}.pth"
        loadPath = path/name
        print(f"Opening model from: {loadPath}")
        self.load_state_dict(torch.load(f=loadPath, map_location=torch.device('cpu')).state_dict() )
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")
    
    def loadModelFromPath(self, model, modelPath, device=torch.device("cpu")) -> None:
        # Loads a saved model as defined in saveModel from a full path

        print(f"Opening model from: {modelPath}")
        model.load_state_dict(torch.load(f=modelPath, map_location=torch.device('cpu')).state_dict() )
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")