from PIL import Image
import torch

# Constants for the reward algorithm
FOUND_CITY_REWARD = 10000
TRACK_PUNISHMENT = 0.1
NEW_TRACK_PUNISHMENT = 10
WATER_PUNISHMENT_MULTIPLIER = 10

def calcReward(iImg, oImg) -> torch.Tensor:
    cityReward = 0.0
    foundCityReward = 0.0
    trackPunishment = 0.0
    newTrackPunishment = 0.0
    totalHeightPunishment = 0.0
    #waterPunishmentAddition = 0.0
    totalReward = 0.0

    # Get pixel data
    tracks = oImg.load()
    data = iImg.load()
    calcPixels = set()
    width, height = iImg.size

    # Iterate through each pixel
    for x in range(width):
        for y in range(height):
            # Check if pixel in RGB image is green
            r, g, b = data[x, y]
            hasTrack = False
            hasConnectedTrack = False
            t = tracks[x,y]
            if (t==0):
                hasTrack = True
                if ( b == 0 ):
                    trackPunishment += TRACK_PUNISHMENT
                else:
                    trackPunishment += (TRACK_PUNISHMENT * WATER_PUNISHMENT_MULTIPLIER)
                    #waterPunishmentAddition += TRACK_PUNISHMENT * WATER_PUNISHMENT_MULTIPLIER
                for x1 in range(-1,1):
                    for y1 in range(-1,1):
                        if (x1 != 0 and y1 != 0): #Not same pixel
                            t2 = tracks[x+x1,y+y1]
                            r1 = data[x+x1,y+y1][0]
                            if (t2 == 0):
                                hasConnectedTrack = True
                                # Height algorithm
                                totalHeightPunishment += abs(r-r1)/2 #Calculates twice from the other pixel

            if g > 0 and hasTrack:
                #print("Found green pixel with tracks")
                cityReward += g
                if (g == 255):
                    foundCityReward += FOUND_CITY_REWARD
            if ( hasTrack and not hasConnectedTrack ):
                newTrackPunishment += NEW_TRACK_PUNISHMENT

            
                

    #print(f"City Reward: {cityReward}")
    #print(f"Track Punishment: {trackPunishment}")
    #print(f"New Track Punishment: {newTrackPunishment}")
    #print(f"Height Diff Punishment: {totalHeightPunishment}")
    #print(f"Water addition: {waterPunishmentAddition}")
    totalReward = (cityReward + foundCityReward) - (trackPunishment + newTrackPunishment + totalHeightPunishment)
    reward = torch.tensor([totalReward], dtype=torch.float32)
    return reward