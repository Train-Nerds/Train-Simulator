import subprocess
import os

print(os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.exe")
os.system("\"" + os.path.abspath(os.path.join(os.getcwd(), os.pardir)) + "\\TrainerdsBuilt.console.exe\"")
