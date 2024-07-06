extends Node2D
###tilemap reading
#
#@onready var map = $noise_map.texture.get_image()
#@onready var width = map.get_width()
#@onready var height = map.get_height()
###@onready var player = get_parent().get_child(1)
#
#signal red
#signal green
#signal blue
#signal alpha
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#print(width, height)
	#map.convert(Image.FORMAT_RGBA8)
	#print(map.get_pixel(1,1))
	#for x in range(height):
		#for y in range(width):
			###format is RGBA
			#var red_color = map.get_pixel(x,y)[0]
			#var green_color = map.get_pixel(x,y)[1]
			#var blue_color = map.get_pixel(x,y)[2]
			#var alpha_color = map.get_pixel(x,y)[3]
#
#
			#emit_signal("red", red_color*255, x, y)
			#emit_signal("green", green_color*255, x, y)
			#emit_signal("blue", blue_color*255, x, y)
			#emit_signal("alpha", alpha_color*255, x, y)
#
			##print(pixel_color * 255)
#
	###generate_chunk(player.position)
	#
	#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#func generate_chunk(position):
	#pass
