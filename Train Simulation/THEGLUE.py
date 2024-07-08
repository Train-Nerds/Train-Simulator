import subprocess
from Python.image_generation import terrainGeneration
import os
import json
import threading

def startGodotProject():
    print(os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.exe")
    os.system("\"" + os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.console.exe\"")
    
godotThread = threading.Thread(target=startGodotProject)

godotThread.start()

print("Bonjour")
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
    print(loadingFile)
    loadingInfo = json.load((loadingFile))
    print(loadingInfo)
    loadingState = loadingInfo['loadingProgress']
    return loadingState
    
hasBegunTerrain = False

#terrainGeneration.main()

while True:
    loadingState = loadLoadingInfo()
    #print(instruction)
    
    match loadingState:
        case 1:
            if(not hasBegunTerrain):
                terrainGeneration.main()
                hasBegunTerrain = True
                print("<---- TERRAIN IS BEING GENERATED, ALLELUJAH ----->")
        case 2:
            print(2)
        case 3:
            print(3)
        case 4:
            print(4)
        case _:
            pass
    