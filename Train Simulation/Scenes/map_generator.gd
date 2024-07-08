extends TileMap
##tilemap output
var altitude = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
##set these for size
var width = 1000
var height = 1000
var minimum = -500000
var maximum = 500000
@onready var stop_amt = 0
@onready var heightmap = Image.create(width, height, false, Image.FORMAT_RGBA8)

@onready var player = $TileMapLocation1
@onready var player2 = $TileMapLocation2

@onready var tile_pos = local_to_map(position)
@onready var tile_pos2 = local_to_map(position)

@onready var camera1 = $"TileMapLocation1/1stTileCam"
@onready var camera2 = $"TileMapLocation2/2ndTileCam"

@onready var map = $TileMapLocation1/heightmap.texture.get_image()
@onready var map2 = $TileMapLocation2/heightmap2.texture.get_image()

#@onready var train_stop = $TileMapLocation1/trainStop
@onready var train = $TileMapLocation1/train
@onready var train2 = $TileMapLocation2/train2

@onready var train_stops_coords = []

@onready var sprites = [$TileMapLocation1/trainStop0, $TileMapLocation1/trainStop1, $TileMapLocation1/trainStop2, $TileMapLocation1/trainStop3, $TileMapLocation1/trainStop4, $TileMapLocation1/trainStop5, $TileMapLocation1/trainStop6, $TileMapLocation1/trainStop7, $TileMapLocation1/trainStop8, $TileMapLocation1/trainStop9, $TileMapLocation1/trainStop10, $TileMapLocation1/trainStop11, $TileMapLocation1/trainStop12, $TileMapLocation1/trainStop13, $TileMapLocation1/trainStop14, $TileMapLocation1/trainStop15, $TileMapLocation1/trainStop16, $TileMapLocation1/trainStop17, $TileMapLocation1/trainStop18, $TileMapLocation1/trainStop19]
@onready var sprites2 = [$TileMapLocation2/trainStop0, $TileMapLocation2/trainStop1, $TileMapLocation2/trainStop2, $TileMapLocation2/trainStop3, $TileMapLocation2/trainStop4, $TileMapLocation2/trainStop5, $TileMapLocation2/trainStop6, $TileMapLocation2/trainStop7, $TileMapLocation2/trainStop8, $TileMapLocation2/trainStop9, $TileMapLocation2/trainStop10, $TileMapLocation2/trainStop11, $TileMapLocation2/trainStop12, $TileMapLocation2/trainStop13, $TileMapLocation2/trainStop14, $TileMapLocation2/trainStop15, $TileMapLocation2/trainStop16, $TileMapLocation2/trainStop17, $TileMapLocation2/trainStop18, $TileMapLocation2/trainStop19]


# Called when the node enters the scene tree for the first time.
func _ready():
	#signal testing, should communicate with noise_read.gd
	#print(width, height)
	
	map.convert(Image.FORMAT_RGBA8)
	map2.convert(Image.FORMAT_RGBA8)
	
	var coordinates = []
	var coordinates2 = []
	
	#print(rectangle.position)
	for x in range(height):
		for y in range(width):
			#getting green pixels, adding to coord vector
			if(map.get_pixel(x,y)[1] > 0):
				coordinates.append(Vector2(x,y))
			##format is RGBA
			write_r((map.get_pixel(x,y)[0]), x, y)
			write_g(map.get_pixel(x,y)[1], x, y, coordinates)
			write_b(map.get_pixel(x,y)[2], x, y)
			write_a(map.get_pixel(x,y)[3], x, y)
			

			
	train.position.x = coordinates[3][0]
	train.position.y = coordinates[3][1]
	

	#print(coordinates)
	#print(train.position)
	for x in range(sprites.size()):
		sprites[x].position = Vector2i(2024,2024)
	for x in range(coordinates.size()):
		sprites[x].position = Vector2i(coordinates[x])

			
	altitude.seed = randi()
	##generate_chunk(player.position)
	
	var file_path_png = OS.get_user_data_dir() + "/heightmap.png"
	var result_png = heightmap.save_png(file_path_png)
	
	if(result_png == OK):
		print("PNG is successfully saved at " + file_path_png)
		#print(stop_amt)
	else:
		print("Ahhhhhhh, the image is burning!")
		
		##second tilemap
	for x in range(height):
		for y in range(width):
			if(map2.get_pixel(x,y)[1] > 0):
				coordinates2.append(Vector2(x,y))
			##format is RGBA
			write_r2((map2.get_pixel(x,y)[0]), x, y)
			write_g2(map2.get_pixel(x,y)[1], x, y, coordinates2)
			write_b2(map2.get_pixel(x,y)[2], x, y)
			write_a2(map2.get_pixel(x,y)[3], x, y)
			
	train2.position.x = coordinates2[3][0]
	train2.position.y = coordinates2[3][1]
			
	for x in range(sprites2.size()):
		sprites2[x].position = Vector2i(2024,2024)
	for x in range(coordinates2.size()):
		sprites2[x].position = Vector2i(coordinates2[x])
			
			
			
			
func write_r(red, x, y):
	if red > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 1, Vector2i(2,round(red*4)))

func write_g(green, x, y, coordinates):
	if green > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 1, Vector2i(1,1))
		

		
func write_b(blue, x, y):
	
	if blue > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 1, Vector2i(3,2))
func write_a(alpha, x, y):
	if alpha < 1:


#redundancy makes lines thicker, like a 3x3 grid
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x + 1, tile_pos.y-height/2 + y - 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x - 1, tile_pos.y-height/2 + y + 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x + 2, tile_pos.y-height/2 + y - 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x - 2, tile_pos.y-height/2 + y + 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x + 2, tile_pos.y-height/2 + y + 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x + 1, tile_pos.y-height/2 + y + 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x - 2, tile_pos.y-height/2 + y - 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos.x-width/2 + x - 1, tile_pos.y-height/2 + y - 1), 1, Vector2i(0,0))
var previous_position = Vector2(-1,-1)
var movement_active = true

func write_r2(red, x, y):
	if red > 0:
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x, tile_pos2.y-height/2 + y), 1, Vector2i(2,round(red*4)))

func write_g2(green, x, y, coordinates2):
	if green > 0:
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x, tile_pos2.y-height/2 + y), 1, Vector2i(1,1))
		

		
func write_b2(blue, x, y):
	
	if blue > 0:
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x, tile_pos2.y-height/2 + y), 1, Vector2i(3,2))
		
func write_a2(alpha, x, y):
	if alpha < 1:


#redundancy makes lines thicker, like a 3x3 grid
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x, tile_pos.y-height/2 + y), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x + 1, tile_pos2.y-height/2 + y - 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x - 1, tile_pos2.y-height/2 + y + 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x + 2, tile_pos2.y-height/2 + y - 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x - 2, tile_pos2.y-height/2 + y + 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x + 2, tile_pos2.y-height/2 + y + 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x + 1, tile_pos2.y-height/2 + y + 1), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x - 2, tile_pos2.y-height/2 + y - 2), 1, Vector2i(0,0))
		set_cell(0, Vector2i(tile_pos2.x-width/2 + x - 1, tile_pos2.y-height/2 + y - 1), 1, Vector2i(0,0))
var previous_position2 = Vector2(-1,-1)
var movement_active2 = true

		
func _process(delta):
	##camera switch call
	if Input.is_action_just_pressed("Space"):
		print("hello")
		toggle_cameras()
		  
		
	if movement_active:
		var moved = false
		for x in range(int(train.position.x) - 1, int(train.position.x) + 2):
			for y in range(int(train.position.y) - 1, int(train.position.y) + 2):
				var pixel_color = map.get_pixel(x, y)
				var new_position = Vector2(x,y)
				if (pixel_color.a < 1 and previous_position != new_position):
					previous_position = train.position
					train.position = new_position
					#print(train.position, previous_position)
					moved = true
					break
			if moved:
				break
				
				
	if movement_active:
		var moved = false
		for x in range(int(train2.position.x) - 1, int(train2.position.x) + 2):
			for y in range(int(train2.position.y) - 1, int(train2.position.y) + 2):
				var pixel_color = map2.get_pixel(x, y)
				var new_position2 = Vector2(x,y)
				if (pixel_color.a < 1 and previous_position != new_position2):
					previous_position = train2.position
					train2.position = new_position2
					#print(train.position, previous_position)
					moved = true
					break
			if moved:
				break
				
				
##switches camera based on 
##space bar press
##activated in delta
func toggle_cameras():
	# Toggle visibility of the current active camera
	print("good looks")
	if camera1.enabled:
		camera1.enabled = false
		camera2.enabled = true
	else:
		camera1.enabled = true
		camera2.enabled = false
		
