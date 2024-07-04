extends Node2D

func to_rgb(x: Image) -> Image:
	if x.get_format() != Image.FORMAT_RGB8:
		x.convert(Image.FORMAT_RGB8);
	return x

func find_cities(x: PackedByteArray) -> PackedVector2Array:
	var cities: PackedVector2Array = [];
	for i in x.size():
		# RGB = [0, 1, 2] => 3 elements; 3*i gets pixel at i, +1 gets G byte.
		if x.decode_s8(3*i+1) == 255: cities.append(Vector2(i, 0));
	return cities

func index_to_coords(columns: int, i: int) -> Vector2:
	var y = i % columns;
	var x = (i - y) / columns;
	return Vector2(x, y)

func compute_center(coordinate_pairs: PackedVector2Array) -> Vector2:
	var center: Vector2 = Vector2(0, 0);
	var amount = coordinate_pairs.size();
	for pair in coordinate_pairs:
		center += pair;
	center /= amount;
	return center

func linear_reduce_average_deviation(input_set: Array):
	var output := [];
	var size = input_set.size();
	for i in range(size):
		for j in range(i, size):
			
			

func _ready():
	var image: Image = to_rgb(Image.load_from_file("res://heightmapR.png"));
	var cities: Array = find_cities(image.get_data());
	for i in cities.size():
		cities[i] = index_to_coords(image.get_width(), cities[i][0]);
	var center: Vector2 = compute_center(cities);
	
	var deviations: Array = cities.map(func(city: Vector2):
		return (city - center));
	var maximum_deviation = deviations.reduce(func(accum, vec: Vector2):
		return max(accum, vec));
	
	

func _process(delta):
	pass
