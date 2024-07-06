from PIL import Image
import PathAlgorithm


class Reward_Function():
    inputImage = None
    outputRailImage = None
    rewardModifier = None
    waterLevel = None
    #cityColor = None
    imageWidth = 1000
    imageHeight = 1000
    cityCoords = []
    grid = []

    def __init__(self, rewardModifier: float, waterLevel: int):
        #self.cityColor = cityColor
        self.waterLevel = waterLevel
        self.rewardModifier = rewardModifier

    def Calculate(self):
        inputImage = None
        outputRailImage = None        
        reward = self.reward_Calculator()
        pass

    def cost_Calculator(self):
        self.inputImage
        self.outputRailImage
        cost = 0
        rail = 0
        plain = 0
        self.grid = [[0 for x in range(self.imageWidth)] for y in range(self.imageHeight)]
        pixilGrid = [[self.outputRailImage[y*self.imageHeight+x] for x in range(self.imageWidth)] for y in range(self.imageHeight-1)]
        '''for pixil_Index in range(len(self.outputRailImage)):
            if(self.outputRailImage[pixil_Index][0] != 255 or self.outputRailImage[pixil_Index][1] != 255 or self.outputRailImage[pixil_Index][2] != 255):
                cost += self.pixil_Cost_Calculator(pixil_Index)
            self.grid += [0]
            rail += 1
        else:
            self.grid += [1]
            plain += 1'''
        for y in range(len(pixilGrid)-1):
            for x in range(len(pixilGrid[y])-1):
                if(pixilGrid[y][x][0] == 0):
                    self.grid[y][x] = 1
                    #print('rail found: ' + str(y) + ' ' + str(x))
                    rail += 1
                    cost += self.pixil_Cost_Calculator(y*self.imageHeight+x)
                else:
                    self.grid[y][x] = 0
                    plain += 1

        print('Cost: ' + str(cost) + ' rails: ' + str(rail) + ' plain: ' + str(plain))
        return(cost)
    def pixil_Cost_Calculator(self, pixil_Index: int):
        terrain_Pixil_Value = self.inputImage[pixil_Index]
        if(terrain_Pixil_Value[0] > self.waterLevel):
            return(2*terrain_Pixil_Value[0])
        else:
            return(terrain_Pixil_Value[0]*terrain_Pixil_Value[0])



    def findCityLocations(self):
        pixilGrid = [[self.inputImage[y*self.imageWidth+x] for x in range(self.imageWidth-1)] for y in range(self.imageHeight-1)]

        #self.grid = [[self.grid[y*self.imageHeight+x] for x in range(self.imageWidth)] for y in range(self.imageHeight)]
        '''temp = []
        for y in range(self.imageHeight-1):
            temp_2 = []
            for x in range(self.imageWidth-1):
                #print(y * self.imageHeight + x)
                temp_2 += [self.grid[y * self.imageHeight + x]]
            temp += [temp_2]
        self.grid = temp'''

        #self.grid = [[temp += self.grid[y * self.imageHeight + x]] for x in range(self.imageWidth-1)] for y in range(self.imageHeight-1)]
        for pixil_Index in range(len(self.inputImage)-1):
            pixil = self.inputImage[pixil_Index]
            
        for y in range(len(pixilGrid)-1):
            for x in range(len(pixilGrid[y])-1):
                if(pixilGrid[y][x][1] >= 192):
                    #print('City Found: ' + str(pixilGrid[y][x]))
                    #print(str(x) + ' ' + str(y) + ' ' + str(pixilGrid[y][x]))
                    self.cityCoords.append([x, y])
                    #self.grid[y][x] = 0

    def efficiency_Value_Calculator(self):
        trainMap_As_Binary = []
        for pixil_Index in range(len(self.outputRailImage)-1):
            #if(self.inputImage[pixil_Index][1] >= 180):
                #print('City Observed')
            if(self.outputRailImage[pixil_Index][0] > 10 or self.inputImage[pixil_Index][1] >= 180):
                trainMap_As_Binary += [0]
            else:                
                trainMap_As_Binary += [1]
        #grid = [[trainMap_As_Binary[y*self.imageWidth+x] for x in range(self.imageWidth-1)] for y in range(self.imageHeight-1)]
        
        value = 0
        efficiency = 0
        for cityCoord in self.cityCoords:
            for connectedCityCoord in self.cityCoords:
                pathLength = PathAlgorithm.a_star_search(grid=self.grid, src=cityCoord, dest=connectedCityCoord)
                if(pathLength >= 0):
                    value += 1
                    efficiency -= pathLength
        #print('Value: ' + str(value))
        #print('Efficiency: ' + str(efficiency))

        return(value, efficiency)

    def reward_Calculator(self, inputImage: Image, outputRailImage: Image, ):
        self.inputImage = list(inputImage.getdata())
        self.outputRailImage = list(outputRailImage.getdata())
        cost = self.cost_Calculator()
        self.findCityLocations()


        value, efficiency = self.efficiency_Value_Calculator()
        reward = pow((self.rewardModifier*value), 2)-(efficiency+cost)
        print(pow(self.rewardModifier, value))
        
        print('Reward Modifier: ' + str(self.rewardModifier))
        print('Cost: ' + str(cost))
        print('Value: ' + str(value))
        print('Efficiency: ' + str(efficiency))
        print('Reward: ' + str(reward))
        cityCoords = []
        grid = []
        return(reward)


