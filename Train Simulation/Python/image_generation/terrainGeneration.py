import noise # type: ignore
import numpy as np # type: ignore
from PIL import Image
import math
import heapq
import random
from scipy.ndimage import gaussian_filter # type: ignore
import sys
import json
import os

def add_color2(informationMap):
    color_world = np.zeros(world.shape+(3,))
    for i in range(shape[0]):
        for j in range(shape[1]):
            if informationMap.getpixel((i, j))[0] < threshold + 52 or informationMap.getpixel((i, j))[2] > 0:
                color_world[i][j] = blue
            elif informationMap.getpixel((i, j))[0] < threshold + 55:
                color_world[i][j] = beach
            elif informationMap.getpixel((i, j))[0] < threshold + 60:
                color_world[i][j] = sandy
            elif informationMap.getpixel((i, j))[0] < threshold + 80:
                color_world[i][j] = green
            elif informationMap.getpixel((i, j))[0] < threshold + 110:
                color_world[i][j] = darkgreen
            elif informationMap.getpixel((i, j))[0] < threshold + 135:
                color_world[i][j] = mountain

            else:
                color_world[i][j] = snow            
                
            if informationMap.getpixel((i, j))[1] > 0:
                value = informationMap.getpixel((i, j))[1]
                color_world[i][j] = [value, value, value]
                

    return color_world

def prepareChannel(world):
    
    color_world = np.zeros(world.shape+(3,))
    for i in range(shape[0]):
        for j in range(shape[1]):
            if world[i][j] < threshold:
                color_world[i][j] = 0
            else:
                color_world[i][j] = world[i][j]

                
    return color_world
           
def a_star_pathfinding(terrain, start, goal):
    def heuristic(a, b):
        return np.linalg.norm(np.array(a) - np.array(b))
    
    def get_neighbors(pos):
        x, y = pos
        directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # Four possible directions: up, down, left, right
        neighbors = [(x + dx, y + dy) for dx, dy in directions]
        valid_neighbors = [(nx, ny) for nx, ny in neighbors if 0 <= nx < len(terrain) and 0 <= ny < len(terrain[0])]
        return valid_neighbors
    
    open_list = []
    heapq.heappush(open_list, (0, start))
    came_from = {}
    g_score = {start: 0}
    f_score = {start: heuristic(start, goal)}
    
    while open_list:
        _, current = heapq.heappop(open_list)
        
        if current == goal:
            path = []
            while current in came_from:
                path.append(current)
                current = came_from[current]
            path.append(start)
            return path[::-1]  # Return reversed path
        
        for neighbor in get_neighbors(current):
            tentative_g_score = g_score[current] + (terrain[neighbor[1], neighbor[0]] - terrain[current[1], current[0]])**2
            if neighbor not in g_score or tentative_g_score < g_score[neighbor]:
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g_score
                f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, goal)
                if neighbor not in [i[1] for i in open_list]:
                    heapq.heappush(open_list, (f_score[neighbor], neighbor))
    
    return []

def generate_rivers(terrain, num_rivers, river_threshold):
    print("Generating Rivers...")
    height, width = terrain.shape
    rivers = np.zeros_like(terrain)
    high_points = [(x, y) for x in range(width) for y in range(height) if terrain[y, x] > river_threshold]
    
    # Function to find the nearest low point for a river to flow to
    def find_goal(start):
        for r in range(1, max(width, height)):
            for dy in range(-r, r+1):
                for dx in range(-r, r+1):
                    nx, ny = start[0] + dx, start[1] + dy
                    if 0 <= nx < width and 0 <= ny < height and terrain[ny, nx] < -0.15:
                        return (nx, ny)
        return None
    
    for _ in range(num_rivers):
        if not high_points:
            break
        start = random.choice(high_points)
        goal = find_goal(start)
        if not goal:
            continue
        
        path = a_star_pathfinding(terrain, start, goal)
        for x, y in path:
            rivers[y, x] = 255  # Mark the river in the blue channel
            #print("River grew!")
            
    for i in range(len(terrain)):
        for j in range(len(terrain[i])):
            if(terrain[i][j] < settings['waterLevel']):
                rivers[i, j] = 255
    
    return rivers

def generate_population(terrain, rivers, num_clusters, growth_steps, growth_probability):
    print("Generating Population...")
    height, width = terrain.shape
    global population
    population = np.zeros((height, width))
    
    i = 0
    for _ in range(num_clusters):
        #print("Creating population cluster")
        while True:
            #print("Choosing a cluster")
            # Randomly choose a center for the cluster
            center_x = random.randint(0, width - 1)
            center_y = random.randint(0, height - 1)
            
            # i += 1
            # print(str(i) + ". Terrain Coord: " + str(terrain[center_y, center_x]))
            # Check if the chosen point is suitable for a city (near but not on a river and mid-elevation)
            if terrain[center_y, center_x] > 0 and terrain[center_y, center_x] < 0.1:
                #print("Calculating city river proximity...")
                river_proximity = np.min([np.sqrt((center_x - rx)**2 + (center_y - ry)**2) for ry, rx in zip(*np.where(rivers == 255))])
                #print("River proximity calculated!")
                if 5 < river_proximity < 50 or 0.02 > random.random():  # The city is between 5 and 50 pixels away from a river
                    break
        
        # Grow the city from the chosen starting point
        #grow_city(population, center_x, center_y, terrain, rivers, growth_steps, growth_probability)
        population[center_x, center_y] = 255
    
    #print("Population generated!")
    return population

#def grow_city(city, start_x, start_y, terrain, rivers, growth_steps, growth_probability):
    #print("Grow city,..")
    height, width = terrain.shape
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # Four possible directions: up, down, left, right
    
    def valid_location(x, y):
        return (0 <= x < width and 0 <= y < height and
                terrain[y, x] > 0 and terrain[y, x] < 0.1 and
                city[y, x] == 0 and rivers[y, x] == 0)
    
    city[start_y, start_x] = 100  # Start the city at the given point
    frontier = [(start_x, start_y)]
    
    for _ in range(growth_steps):
        if not frontier:
            break
        
        # Choose a random point from the frontier to grow from
        x, y = random.choice(frontier)
        
        # Try to grow the city in each direction with a certain probability
        for dx, dy in directions:
            if random.random() < growth_probability:
                nx, ny = x + dx, y + dy
                if valid_location(nx, ny):
                    city[ny, nx] = 255
                    #print("City grew!")
                    frontier.append((nx, ny))
        
        # Remove the point from the frontier to prevent regrowth
        frontier.remove((x, y))

def rgb_norm(world):
    world_min = np.min(world)
    world_max = np.max(world)
    norm = lambda x: (x-world_min/(world_max - world_min))*255
    return np.vectorize(norm)

def prep_world(world):
    norm = rgb_norm(world)
    world = norm(world)
    return world


def main():
    #importing settings from Godot

    # COMMENT OUT 205 FOR VSCODE, WHEN USING COMMAND PROMPT, COMMENT ABOUT 206
    thisPath = os.getcwd()
    #thisPath = os.getcwd() + "\\Desktop\\Documents\\GitHub\\Train-Simulator\\Train Simulation\\Python\\image_generation"

    loadingFilePath = os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\loadingCommunication.bin"
    
    loadingFile = open(loadingFilePath, "w")
    loadingFile.write("")
    loadingFile.close()

    file = open("C:\\Users\\bbsaw\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\settings.bin")
    global settings
    settings = json.load(file)

    file.close()

    # loadingFile = open(loadingFilePath, "a")
    # loadingFile.write("0")
    # loadingFile.close()

    global shape
    shape = (1000,1000)
    scale = settings['noiseScale']
    octaves = settings['octaves']
    persistence = 0.5
    lacunarity = float(settings['lacunarity'])
    seed = settings['seed']
    cities_amt = settings['cities_amt']
    
    print(seed)
    world = np.zeros(shape)
    for i in range(shape[0]):
        for j in range(shape[1]):
            world[i][j] = noise.pnoise2(i/scale, 
                                        j/scale, 
                                        octaves=octaves, 
                                        persistence=persistence, 
                                        lacunarity=lacunarity, 
                                        repeatx=1000, 
                                        repeaty=1000, 
                                        base=seed)
            
    center_x, center_y = shape[1] // 2, shape[0] // 2
    circle_grad = np.zeros_like(world)
    for y in range(world.shape[0]):
        for x in range(world.shape[1]):
            distx = abs(x - center_x)
            disty = abs(y - center_y)
            dist = math.sqrt(distx*distx + disty*disty)
            circle_grad[y][x] = dist
    # get it between -1 and 1
    max_grad = np.max(circle_grad)
    circle_grad = circle_grad / max_grad
    circle_grad -= 0.8
    circle_grad *= 1.2
    circle_grad = -circle_grad
    world_noise = np.zeros_like(world)
    for i in range(shape[0]):
        for j in range(shape[1]):
            #if circle_grad[i][j] > 0:
            world_noise[i][j] = (world[i][j] * circle_grad[i][j])
    print("Terrain Generated!")

    loadingFile = open(loadingFilePath, "w")
    loadingInfo = {
        "loadingProgress" : 1
    }
    
    json.dump(loadingInfo, loadingFile)
    loadingFile.close()

    lightblue = [0,191,255]
    blue = [65,105,225]
    green = [34,139,34]
    darkgreen = [0,100,0]
    sandy = [210,180,140]
    beach = [238, 214, 175]
    snow = [255, 250, 250]
    mountain = [139, 137, 137]
    global threshold
    threshold = 50
    rivers = generate_rivers(world_noise.copy(), 20, 0.1)

    loadingFile = open(loadingFilePath, "w")
    loadingInfo = {
        "loadingProgress" : 2
    }
    
    json.dump(loadingInfo, loadingFile)
    loadingFile.close()

    population = generate_population(world_noise.copy(), rivers, cities_amt, 1, .1)
    
    loadingFile = open(loadingFilePath, "w")
    loadingInfo = {
        "loadingProgress" : 3
    }
    
    json.dump(loadingInfo, loadingFile)
    loadingFile.close()

    heightmap_grad = prepareChannel(prep_world(world_noise)).astype(np.uint8)
    heightmap = Image.fromarray(heightmap_grad)
    rivermap = Image.fromarray(rivers.astype(np.uint8))
    #rivermap.save("rivermap.png")
    populationMap = Image.fromarray(population.astype(np.uint8))
    #populationMap.save("populationmap.png")
    heightmap = heightmap.convert("L")
    informationMap = Image.merge("RGB", (heightmap, populationMap, rivermap))
    informationMap.save(os.path.expanduser( "~" ) + "\\AppData\\Roaming\\Godot\\app_userdata\\Train Simulation\\informationMap.png")
    #informationMap.show()
    #Image.fromarray(add_color2(informationMap).astype(np.uint8)).show()

    loadingFile = open(loadingFilePath, "w")
    loadingInfo = {
        "loadingProgress" : 4
    }
    
    json.dump(loadingInfo, loadingFile)
    loadingFile.close()