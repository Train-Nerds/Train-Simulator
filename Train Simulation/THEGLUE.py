import subprocess
from Python.image_generation import terrainGeneration
import Python.Yale_Trainerds
from Python.Yale_Trainerds import MLPathCreator as ml
from Python.Yale_Trainerds import Model1
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
    try:
        loadingInfo = json.load((loadingFile))
        print(loadingInfo)
        loadingState = loadingInfo['loadingProgress']
        return loadingState
    except:
        pass
    
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
                hasBegunAiGeneration = False
                print("creating image")
                informationMap = Image.open(os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\informationMap.png")
                informationMap.show()
                print("information map found")
                AIoutput = ml.generateTracks(informationMap)
                print("AI is done")
                AIoutput.save(os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\AiOutput.png")
                loadingFile = open(instructionFilePath, "w")
                
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
    