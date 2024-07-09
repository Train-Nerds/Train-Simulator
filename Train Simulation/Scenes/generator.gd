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
		var color: Color = image.get_pixelv(head);
		var h_height = color[0];
		var x_grad = abs(h_height - image.get_pixelv(head + Vector2(dxdy[0], 0))[0]);
		var y_grad = abs(h_height - image.get_pixelv(head + Vector2(0, dxdy[1]))[0]);
		is_y = y_grad <= x_grad and dxdy[1] as bool or not dxdy[0] as bool;
		var turn = is_y as int;
		
		# look ahead and see if there is water
		if image.get_pixelv(head + dxdy[turn])[2] > 0:
			var river = image.get_pixelv(head + 3*dxdy[turn])[2] == 0;
		# if there is a river, cross it.
		# if there is a lake, go around
		
		head[turn] += dxdy[turn];
		if (a-head)[turn] == 0: dxdy[turn] = 0;
		color[3] = 0;
		image.set_pixelv(head, color);
	return image;

func get_point_out_of_water(point: Vector2, image: Image) -> Vector2:
	var land_pixels: PackedVector2Array = [];
	var width = image.get_width();
	var height = image.get_height();
	for x in range(width):
		for y in range(height):
			if image.get_pixel(x,y)[2] == 0:
				land_pixels.append(Vector2(x,y));
	var min_p = land_pixels[0];
	for i in range(1, land_pixels.size()):
		if abs(point-land_pixels[i]) < abs(point-min_p):
			min_p = land_pixels[i];
	return min_p;

func pythag_center(points: Array) -> Vector2:
	var sum = Vector2(0, 0);
	for v in points:
		sum[0] += v[0]**2;
		sum[1] += v[1]**2;
	sum[0] = roundi(sqrt(sum[0]))
	sum[1] = roundi(sqrt(sum[1]))
	return sum

func run(input_path: String, output_path: String) -> Image:
	var image: Image = copy_to_rgba(Image.load_from_file(input_path));
	var cities: Array = find_cities(image);
	var center: Vector2 = pythag_center(cities);
	
	var deviations: Array = cities.map(func(city: Vector2): return (city - center));
	var maximum_deviation: Vector2 = deviations.reduce(func(accum, vec: Vector2): return vec_max(accum, vec));
	
	center = get_point_out_of_water(center, image);

	for city in cities:
		image = path(center, city, image);
		var color = image.get_pixelv(city);
		color[3] = 255;

		image.set_pixelv(city, color);	

	image.save_png(output_path);
	
	return image;

func _ready():
	run("res://Scenes/Input_Image.png", "/home/pin/output.png")
	pass
	
func _process(delta):
	pass
