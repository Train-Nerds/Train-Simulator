import subprocess
from Python.image_generation import terrainGeneration
# from Python.Machine_Learning import MLPathCreator
# import Python.Machine_Learning.Model1 as m1
import torch
from PIL import Image
import os
import json
import threading

def startGodotProject():
    print(os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.exe")
    os.system("\"" + os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.console.exe\"")
    
godotThread = threading.Thread(target=startGodotProject)

godotThread.start()

print("Hej")
i = 0

instructionFilePath = os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\loadingCommunication.bin"

loadingFile = open(instructionFilePath, "w")
loadingInfo = {
    "loadingProgress" : 0
}

json.dump(loadingInfo, loadingFile)
loadingFile.close()
    
def loadLoadingInfo():
    loadingFile = open(instructionFilePath)
    #print(loadingFile)
    loadingInfo = json.load((loadingFile))
    print(loadingInfo)
    loadingState = loadingInfo['loadingProgress']
    return loadingState
    
hasBegunTerrain = False
hasBegunAiGeneration = False

#terrainGeneration.main()

while True:
    loadingState = loadLoadingInfo()
    print(loadingState)
    
    match loadingState:
        case 1:
            if(not hasBegunTerrain):
                terrainGeneration.main()
                hasBegunTerrain = True
                print("<---- TERRAIN IS BEING GENERATED, ALLELUJAH ----->")
        case 2:
            print(2)
        case 3:
            #print(3)
            pass
        case 4:
            print(4)
        case 5:
            print(5)
            if(not hasBegunAiGeneration):
                # hasBegunAiGeneration = False
                # informationMap = Image.open(os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\informationMap.png")
                # print("information map found")
                # AIoutput = MLPathCreator.generateTerrain(informationMap)
                # print("AI is done")
                # AIoutput.save(os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\AiOutput.png")
                # loadingFile = open(instructionFilePath, "w")
                loadingInfo = {
                    "loadingProgress" : 6
                }
                
                json.dump(loadingInfo, loadingFile)
                loadingFile.close()
                
            
        case 6:
            print(6)
        case 7:
            pass
        case _:
            pass
    