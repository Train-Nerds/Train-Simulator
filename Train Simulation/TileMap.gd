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
@onready var heightmap = Image.create(width, height, false, Image.FORMAT_RGBA8)
@onready var player = $"../player"
@onready var tile_pos = local_to_map(position)
@onready var map = $"../noise_map".texture.get_image()


# Called when the node enters the scene tree for the first time.
func _ready():
	#signal testing, should communicate with noise_read.gd
	print(width, height)
	map.convert(Image.FORMAT_RGBA8)
	print(map.get_pixel(1,1))
	for x in range(height):
		for y in range(width):
			##format is RGBA
			write_r((map.get_pixel(x,y)[0])*255, x, y)
			write_g(map.get_pixel(x,y)[1], x, y)
			write_b(map.get_pixel(x,y)[2], x, y)
			write_a(map.get_pixel(x,y)[3], x, y)
			
			
			
	altitude.seed = randi()
	##generate_chunk(player.position)
	
	var file_path_png = OS.get_user_data_dir() + "/heightmap.png"
	var result_png = heightmap.save_png(file_path_png)
	
	if(result_png == OK):
		print("PNG is successfully saved at " + file_path_png)
	else:
		print("Ahhhhhhh, the image is burning!")
	
func write_r(red, x, y):
		if red > 0:
			set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(round(red/63.75),round(red/63.75)))

func write_g(green, x, y):
	if green > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(2,0))
	
func write_b(blue, x, y):
	
	if blue > 0:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(3,2))
func write_a(alpha, x, y):
	if alpha < 1:
		set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(0,3))


#signal testing


# Called every frame. 'delta' is the elapsed time since the previous frame.

#
#func generate_chunk(position):
	#var tile_pos = local_to_map(position)
	#for x in range(width):
		#for y in range(height):
			#var alt = altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			#heightmap.set_pixel(x, y, Color(round((alt+10)/5), 0, 0, 255))
			#
			#if(alt > maximum):
				#maximum = alt
			#elif (alt < minimum):
				#minimum = alt
			#var temp = temperature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			#var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
##			set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(1,1))
			#if alt < 2:
					#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(0, round((moist+10)/5)))
			#else:
					#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(round((alt+10)/5), round((alt+10)/5)))
	#
	#print("Max: " + str(maximum) + ", Min: " + str(minimum))
	#
#
#func _on_procedural_generation_red(red, x, y):
	#var tile_pos = local_to_map(position)
	#if red > 0:
		#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(round(red/63.75),round(red/63.75)))
#
#


#func _on_procedural_generation_red(red, x, y):
	#var tile_pos = local_to_map(position)
	#if red > 0:
		#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(round(red/63.75),round(red/63.75)))


#func _on_procedural_generation_green(green, x, y):
	#var tile_pos = local_to_map(position)
	#if green > 0:
		#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(2,0))
	
#func _on_procedural_generation_blue(blue, x, y):
	#var tile_pos = local_to_map(position)
	#if blue > 0:
		#set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(3,2))
#func _on_procedural_generation_alpha(alpha, x, y):
	#if alpha > 1:
		#pass


