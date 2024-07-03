extends Node2D

func to_rgb(x: Image) -> Image:
	if x.get_format() != Image.FORMAT_RGB8:
		x.convert(Image.FORMAT_RGB8);
	return x

func find_cities(x: PackedByteArray) -> Array:
	var cities: Array = [];
	for i in x.size():
		# RGB = [0, 1, 2] => 3 elements; 3*i gets pixel at i, +1 gets G byte.
		if x.decode_s8(3*i+1) == 255:
			cities.append(i);
	return cities

func index_to_coords(columns: int, i: int) -> Array:
	var y = i % columns;
	var x = (i - y) / columns;
	return [x, y]

func _ready():
	var image: Image = to_rgb(Image.load_from_file("res://heightmapR.png"));
	var cities: Array = find_cities(image.get_data());
	
	for i in cities.size():
		cities[i] = index_to_coords(image.get_width(), cities[i]);
	
	pass

func _process(delta):
	pass
