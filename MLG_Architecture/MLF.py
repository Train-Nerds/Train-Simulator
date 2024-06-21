import os
import numpy as np
import pandas as pd


splineDataCollums = ['Start X', 'Start Y', 'Start Angle', 'Start Strength', 'End X', 'End Y', 'End Angle', 'End Strength']
splineDataRows = [[0.3, 2.0, 1.0, 0.20, 1.0, 4.0, 0.3, 0.4],[0.3, 2.0, 1.0, 0.20, 1.0, 4.0, 0.3, 0.4],[0.3, 2.0, 1.0, 0.20, 1.0, 4.0, 0.3, 0.4]]

inputImageHeight = 1000
inputImageWidth = 2000

SelectionHeight = 100
SelectionWidth = 100


modelInputSize = inputImageHeight * inputImageWidth + 2 #2 represents the Selection x and y coords from the prev iteration

exampleScreen = pd.DataFrame(np.array([[0,1,1,2,3,4] * (1000 * 1000)]),columns=['R','G','B','A'])


Spline_List = []



def get_Encoded_And_Initialized_Data():
    data = exampleScreen
    return(data)

def SendSplines():
    spline_Data = pd.DataFrame(np.array(splineDataRows),columns=splineDataCollums)
    print('attempting')
    spline_Data.to_csv(path_or_buf='MLG_Architecture\Spline_Sender.csv')

def get_RGBA_Array_Section():
    return(None) #Implementation Here


def runModel():
    Full_RGBA_Array = get_Encoded_And_Initialized_Data()
    RGBA_Selection_Value_Array = get_RGBA_Array_Section()
        
    
class MLG_Input:
    Full_RGBA_Array = Full_RGBA_Array()
    Section_X_Position = 0
    Section_Y_Position = 0
    Spline_List = []
    def __init__(self, Full_RGBA_Array, Section_X_Position, Section_Y_Position, Spline_List):
        self.Full_RGBA_Array = Full_RGBA_Array
        self.Section_X_Position = Section_X_Position
        self.Section_Y_Position = Section_Y_Position
        self.Spline_List = Spline_List
    def get_Full_RGBA_Array(self):
        return(self.Full_RGBA_Array)
    def get_Section_X_Position(self):
        return(self.Section_X_Position)
    def get_Section_Y_Position(self):
        return(self.Section_Y_Position)
    def get_Spline_List(self):
        return(self.Spline_List)
    
    def set_Full_RGBA_Array(self, Full_RGBA_Array):
        self.Full_RGBA_Array = Full_RGBA_Array
    def set_Section_X_Position(self, Full_RGBA_Array):
        self.Full_RGBA_Array = Full_RGBA_Array
    def set_Section_Y_Position(self, Section_Y_Position):
        self.Section_Y_Position = Section_Y_Position
    def set_Spline_List(self, Spline_List):
        self.Spline_List = Spline_List
    
class Full_RGBA_Array:
    imageDataTable = None
    def __init__(self, data: pd):
        self.imageDataTable = data
    def get_RGBA_at_Point(self, X: int, Y: int):
        indexFromCoord = inputImageWidth * X + Y
        RGBA = [self.imageDataTable['R'].iloc(indexFromCoord),self.imageDataTable['G'].iloc(indexFromCoord),self.imageDataTable['B'].iloc(indexFromCoord),self.imageDataTable['A'].iloc(indexFromCoord)]
        return(RGBA)
    def write_RGBA_at_Point(self, X: int, Y: int, RGBA: list):
        indexFromCoord = inputImageWidth * X + Y
        self.imageDataTable['R'].iloc(indexFromCoord) = RGBA[0]
        self.imageDataTable['G'].iloc(indexFromCoord) = RGBA[1]
        self.imageDataTable['B'].iloc(indexFromCoord) = RGBA[2]
        self.imageDataTable['A'].iloc(indexFromCoord) = RGBA[3]
    
    def get_Selection(self, SelectionHeight, SelectionWidth):
        selectionData = []
        for x in range (SelectionWidth):
            for y in range (SelectionHeight):
                selectionData.append(self.get_RGBA_at_Point(x,y))
        selection = RGBA_Section(selectionData)
        return(selection)
    
    def write_Selection(self):
        for x in range (SelectionWidth):
            for y in range (SelectionHeight):
                self.write_RGBA_at_Point()
    
class RGBA_Section:
    selection = None
    def __init__(data: list):
        selection = pd.DataFrame(np.array(list),columns=['R','G','B','A'])
    def get_RGBA_at_Point(self, X: int, Y: int):
        indexFromCoord = inputImageWidth * X + Y
        RGBA = [self.selection['R'].iloc(indexFromCoord),self.selection['G'].iloc(indexFromCoord),self.selection['B'].iloc(indexFromCoord),self.selection['A'].iloc(indexFromCoord)]
        return(RGBA)
