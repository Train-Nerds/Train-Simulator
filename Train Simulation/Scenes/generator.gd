extends Node2D

@onready var LOAD_INFO_PATH: String = "user://loadingCommunication.bin"

func copy_to_rgba(x: Image) -> Image:
	var image = Image.create_from_data(1000, 1000, false, Image.FORMAT_RGB8, x.get_data());
	image.convert(Image.FORMAT_RGBA8);
	return image;

func find_cities(p: Image) -> Array:
	var cities: Array = [];
	var width: int = p.get_width();
	var height: int = p.get_height();
	for x in range(width):
		for y in range(height):
			if p.get_pixel(x, y)[1] > 0:
				cities.append(Vector2(x, y));
		
	return cities

func index_to_coords(columns: int, i: int) -> Vector2:
	var y = i % columns;
	var x = (i - y) / columns;
	return Vector2(x, y)

func coords_to_index(columns: int, x: int, y: int) -> int:
	return y * columns + x;

func compute_center(coordinate_pairs: Array) -> Vector2:
	print(coordinate_pairs)
	var center: Vector2 = Vector2(0, 0);
	var amount = coordinate_pairs.size();
	for pair in coordinate_pairs:
		center += pair;
	center[0] /= amount; center[1] /= amount;
	center[0] = roundi(center[0]); center[1] = roundi(center[1]);
	print(center)
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

func path(a: Vector2, b: Vector2, image: Image) -> Image:
	if (b == vec_max(a, b)): var t = a; a = b; b = t;
	var diff: Vector2 = a-b;
	var dxdy = Vector2(sign(diff[0]), sign(diff[1]));
	var head = b;
	var is_y: bool = false;
	while(head != a):
		var turn = is_y as int;
		head[turn] += dxdy[turn];
		if (a-head)[turn] == 0: dxdy[turn] = 0;
		var color: Color = image.get_pixelv(head);
		color[3] = 0;
		image.set_pixelv(head, color);
		is_y = not is_y;
	return image;



func run(input_path: String, output_path: String) -> Image:
	var image: Image = copy_to_rgba(Image.load_from_file(input_path));
	var cities: Array = find_cities(image);
	var center: Vector2 = compute_center(cities);
	
	var deviations: Array = cities.map(func(city: Vector2): return (city - center));
	var maximum_deviation: Vector2 = deviations.reduce(func(accum, vec: Vector2): return vec_max(accum, vec));

	var branches: Array = [0,];
	for i in range(1, deviations.size()):
		if deviations[i] - deviations[i-1] > Vector2(100, 100):
			branches.append(i);
			
	for city in cities:
		image = path(center, city, image);
		
	image.save_png(output_path);
	
	return image;

func _ready():
	#run("res://Scenes/Input_Image.png", "user://proceduralRailOutput.png")
	pass
	
func _process(delta):
	pass
