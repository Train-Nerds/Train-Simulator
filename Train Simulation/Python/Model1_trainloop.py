import torch
from pathlib import Path
from torch import nn
import RewardAlgorithm
from RewardAlgorithm import calcReward

class MainModel(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        # 3 input channels, one for each RGB channel
        # 32 output channels
        # Kernel size of 3 to analyze a 3x3 area
        # Stride of 1 to analyze the pixels directly next to the current one
        # Padding to maintain the same 2d shape
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, stride=1, padding=2)
        # Normalize data from Conv2d, 32 input channels
        self.bn2 = nn.BatchNorm2d(32)
        # Relu algorithm to ensure no negative values and introduce complexity through big maths
        self.relu = nn.ReLU()
        self.mp3 = nn.MaxPool2d(kernel_size=2, stride=2)
        # Upsample
        self.deconv4 = nn.ConvTranspose2d(32,1,kernel_size=2, stride=2)


    def forward(self, x: torch.Tensor) -> torch.Tensor:
        try:
            x = self.conv1(x)
        except:
            print("error convoluting")
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
    
    def train_model(self, dataloader, scedStep, scedGamma, printProgress, epochs=25):
        optimizer = torch.optim.SGD(self.parameters(),lr=0.001)
        scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=scedStep, gamma=scedGamma)

        for epoch in range(epochs):
            self.train()             
            for inputs, outputs in dataloader:                
                optimizer.zero_grad()
                outputs = self(inputs)
                loss = calcReward(inputs, outputs)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                scheduler.step()

                percent = (epoch/epochs)*100
                if (printProgress and (percent % 1 == 0)):
                    print(f"{percent}%")
        return self.eval()


    def saveModel(self,name, folderName="models"):
        path = Path(folderName)
        path.mkdir(parents=True,exist_ok=True)
        name = f"{name}.pth" #.pth or PyTorch State file
        savePath = path/name
        print(f"Saving model to: {savePath}")
        torch.save(self,f=savePath)
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")
    
    def loadModel(self,modelName, folderName="models"):
        path = Path(folderName)
        name = f"{modelName}.pth"
        loadPath = path/name
        print(f"Opening model from: {loadPath}")
        self.load_state_dict(torch.load(f=loadPath).state_dict())
        #for name, param in self.named_parameters():
        #    print(f"{name}: {param}")
    