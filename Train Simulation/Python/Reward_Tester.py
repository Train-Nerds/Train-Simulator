import RewardFunction
from PIL import Image

rewardFunction = RewardFunction.Reward_Function(30000, 100)

inputImage = Image.open("Input_Image.png")
outputImage = Image.open("Output_Image.png")

reward = rewardFunction.reward_Calculator(inputImage, outputImage)

print(reward)