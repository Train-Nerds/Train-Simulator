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
@onready var player = $player
@onready var tile_pos = local_to_map($player.position)
@onready var map = $heightmap.texture.get_image()

@onready var train_stop = $trainStop
@onready var train = $train
@onready var train_stops_coords = []
@onready var sprites = [$trainStop0,$trainStop1,$trainStop2, $trainStop3, $trainStop4, $trainStop5, $trainStop6, $trainStop7, $trainStop8, $trainStop9, $trainStop10, $trainStop11, $trainStop12, $trainStop13, $trainStop14, $trainStop15, $trainStop16, $trainStop17, $trainStop18, $trainStop19]
@onready var trains = [$train0, $train1, $train2, $train3, $train4, $train5, $train6, $train7, $train8, $train9, $train10, $train11, $train12, $train13, $train14, $train15, $train16, $train17, $train18, $train19]


# Called when the node enters the scene tree for the first time.
func _ready():
	#signal testing, should communicate with noise_read.gd
	print(width, height)
	map.convert(Image.FORMAT_RGBA8)
	var coordinates = []
	var alphas = []
	#print(rectangle.position)
	for x in range(height):
		for y in range(width):
			#getting green pixels, adding to coord vector
			if(map.get_pixel(x,y)[1] > 0):
				coordinates.append(Vector2(x,y))
			elif (map.get_pixel(x,y)[3] < 1):
				alphas.append(Vector2(x,y))
			##format is RGBA
			write_r((map.get_pixel(x,y)[0]), x, y)
			write_g(map.get_pixel(x,y)[1], x, y, coordinates)
			write_b(map.get_pixel(x,y)[2], x, y)
			write_a(map.get_pixel(x,y)[3], x, y)
	
	print(coordinates)
	#print(train.position)
	for i in range(sprites.size()):
		sprites[i].position = Vector2i(2024,2024)
		trains[i].position = Vector2i(2024,2024)
	for i in range(coordinates.size()):
		var randindex = randi() % alphas.size()
		sprites[i].position = Vector2i(coordinates[i])
		trains[i].position = Vector2(alphas[randindex])
		
	altitude.seed = randi()
	##generate_chunk(player.position)
	
	var file_path_png = OS.get_user_data_dir() + "/heightmap.png"
	var result_png = heightmap.save_png(file_path_png)
	
	if(result_png == OK):
		print("PNG is successfully saved at " + file_path_png)
		#print(stop_amt)
	else:
		print("Ahhhhhhh, the image is burning!")
	
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
var positions_history=[]
var iteration_count=0

#func _process(delta):
	#if movement_active:
		#var moved = false
		#for x in range(int(train.position.x) - 1, int(train.position.x) + 2):
			#for y in range(int(train.position.y) - 1, int(train.position.y) + 2):
				#var pixel_color = map.get_pixel(x, y)
				#var new_position = Vector2(x,y)
				#if (pixel_color.a < 1 and not new_position in positions_history):
					#previous_position = train.position
					#train.position = new_position
					#positions_history.append(previous_position)
					#iteration_count+=1
					#if iteration_count % 5 == 0 and positions_history.size() > 0:
						#for i in range(1,2):
							#positions_history.remove_at(i)
					#moved = true
					#break
			#if moved:
				#break
