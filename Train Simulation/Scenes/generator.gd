extends Node2D

func to_rgb(x: Image) -> Image:
	if x.get_format() != Image.FORMAT_RGB8:
		x.convert(Image.FORMAT_RGB8);
	return x

func find_cities(x: PackedByteArray) -> PackedVector2Array:
	var cities: PackedVector2Array = [];
	var i = 0;
	var j = 0
	for byte in x:
		if j == 1: if byte as int > 0: cities.append(Vector2(i, 0));
		if j == 2: j = 0;
		else: j += 1;
		i += 1;
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

func linear_reduce_average_deviation(input_set: Array) -> Array:
	var output := [];
	var size = input_set.size();
	for i in range(size):
		for j in range(i+1, size):
			output.append((input_set[i] + input_set[j]) / 2)
	return output

func vec_max(a: Vector2, b: Vector2) -> Vector2:
	var _max: Vector2 = a;
	if b > a: _max = b;
	return _max;

func _ready():
	var image: Image = to_rgb(Image.load_from_file("res://heightmapR.png"));
	var cities: Array = find_cities(image.get_data());
	for i in cities.size():
		cities[i] = index_to_coords(image.get_width(), cities[i][0]);
	var center: Vector2 = compute_center(cities);
	
	var deviations: Array = cities.map(func(city: Vector2): return (city - center));
	var maximum_deviation: Vector2 = deviations.reduce(func(accum, vec: Vector2): return vec_max(accum, vec));
	
	var foo: Array = [];
	for i in range(deviations.size()):
		var cur: Vector2 = deviations[i];
		var r = sqrt(cur[0]**2 + cur[1]**2);
		foo.append(Vector2(r, i));
	foo.sort_custom(func(a: Vector2, b: Vector2): return b > a);
	
	var branches: int = ceil(cities.size() as float / 2);
	
	#print(deviations)
	print(maximum_deviation)

func _process(delta):
	pass
