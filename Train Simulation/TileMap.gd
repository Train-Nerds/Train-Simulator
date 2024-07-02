extends TileMap
##tilemap output
var altitude = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
##set these for size
var width = 1000
var height = 1000
##@onready var player = get_parent().get_child(1)
var minimum = -500000
var maximum = 500000
@onready var heightmap = Image.create(width, height, false, Image.FORMAT_RGBA8)




# Called when the node enters the scene tree for the first time.
func _ready():
	#signal testing, should communicate with noise_read.gd
	var emitter_node = get_node("ProceduralGeneration")
	emitter_node.connect("beans", _on_my_signal_received)
	
	
	altitude.seed = randi()
	##generate_chunk(player.position)
	
	var file_path_png = OS.get_user_data_dir() + "/heightmap.png"
	var result_png = heightmap.save_png(file_path_png)
	
	if(result_png == OK):
		print("PNG is successfully saved at " + file_path_png)
	else:
		print("Ahhhhhhh, the image is burning!")
	

#signal testing
func _on_my_signal_received(value):
	print("hello")
	print(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	##print("Max: " + str(maximum) + ", Min: " + str(minimum))


func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var alt = altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			heightmap.set_pixel(x, y, Color(round((alt+10)/5), 0, 0, 255))
			
			if(alt > maximum):
				maximum = alt
			elif (alt < minimum):
				minimum = alt
			var temp = temperature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
#			set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2i(1,1))
			if alt < 2:
					set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(0, round((moist+10)/5)))
			else:
					set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y), 0, Vector2(round((alt+10)/5), round((alt+10)/5)))
	
	print("Max: " + str(maximum) + ", Min: " + str(minimum))
	

