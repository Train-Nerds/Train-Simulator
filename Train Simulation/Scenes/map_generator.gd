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
@onready var tile_pos = local_to_map(position)
@onready var map = $"heightmap".texture.get_image()

@onready var train_stop1 = $trainStop1
@onready var train_stop2 =$trainStop2
@onready var train_stop3 = $trainStop3

@onready var rectangle = $rectangle




# Called when the node enters the scene tree for the first time.
func _ready():
	#signal testing, should communicate with noise_read.gd
	print(width, height)
	map.convert(Image.FORMAT_RGBA8)
	print(map.get_pixel(1,1))
	var coordinates = []
	#print(rectangle.position)
	for x in range(height):
		for y in range(width):
			#getting green pixels, adding to coord vector
			if(map.get_pixel(x,y)[1] > 0):
				coordinates.append(Vector2(x,y))
			##format is RGBA
			write_r((map.get_pixel(x,y)[0])*255, x, y)
			write_g(map.get_pixel(x,y)[1], x, y)
			write_b(map.get_pixel(x,y)[2], x, y)
			write_a(map.get_pixel(x,y)[3], x, y)
	rectangle.position.x = coordinates[0][0]
	rectangle.position.y = coordinates[0][1]
	print(coordinates)
	print(rectangle.position)
	altitude.seed = randi()
	##generate_chunk(player.position)
	
	var file_path_png = OS.get_user_data_dir() + "/heightmap.png"
	var result_png = heightmap.save_png(file_path_png)
	
	if(result_png == OK):
		print("PNG is successfully saved at " + file_path_png)
		print(stop_amt)
	else:
		print("Ahhhhhhh, the image is burning!")
	
func write_r(red, x, y):
	if red > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(round(red/63.75),round(red/63.75)))

func write_g(green, x, y):
	if green > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(2,0))
		stop_amt += 1
		print(stop_amt)
		train_stop1.position = Vector2(x,y)
		

		
func write_b(blue, x, y):
	
	if blue > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(3,2))
func write_a(alpha, x, y):
	if alpha < 1:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(2,0))


var previous_position = Vector2(-1,-1)
var movement_active = false
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		movement_active = true
	elif movement_active:
		var moved = false
		var target_position = null
		for x in range(int(rectangle.position.x) - 1, int(rectangle.position.x) + 2):
			for y in range(int(rectangle.position.y) - 1, int(rectangle.position.y) + 2):
				var pixel_color = map.get_pixel(x, y)
				if(pixel_color.a < 1):
					target_position = Vector2(x,y)
					print(target_position)
					break
			if target_position != null:
				break
		if target_position != null:
			var move_distance = 100 * delta
			var direction = (target_position - rectangle.position).normalized()
			rectangle.position += direction * move_distance
			print(rectangle.position)
			moved = true
