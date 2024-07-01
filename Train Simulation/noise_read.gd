@tool
extends Node2D


@onready var map = $noise_map.texture.get_image()
@onready var width = map.get_width()
@onready var height = map.get_height()
##@onready var player = get_parent().get_child(1)

signal beans(beans_amt)
# Called when the node enters the scene tree for the first time.
func _ready():
	print(width, height)
	map.convert(Image.FORMAT_RGBA8)
	print(map.get_pixel(1,1))
	for x in range(height):
		for y in range(width):
			var pixel_color = map.get_pixel(x,y)
			##print(pixel_color * 255)
	##generate_chunk(player.position)
	emit_signal("beans", "freak")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_chunk(position):
	pass
