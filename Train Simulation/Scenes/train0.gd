extends Sprite2D

#@onready var previous_position = Vector2(-1,-1)
#@onready var movement_active = false
#@onready var positions_history=[]
#@onready var iteration_count=0

@onready var coordinates=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(1000):
		for y in range(1000):
			#getting green pixels, adding to coord vector
			if(map.get_pixel(x,y)[1] > 0):
				coordinates.append(Vector2(x,y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
var previous_position = Vector2(-1,-1)
var movement_active = true
var positions_history=[]
var iteration_count=0
@onready var map = get_node("../heightmap").texture.get_image()


func _process(delta):
	if movement_active:
		var moved = false
		for x in range(int(self.position.x) - 1, int(self.position.x) + 2):
			for y in range(int(self.position.y) - 1, int(self.position.y) + 2):
				var pixel_color = map.get_pixel(x, y)
				var new_position = Vector2(x,y)
				if (pixel_color.a == 0 and not new_position in positions_history):
					previous_position = self.position
					self.position = new_position
					positions_history.append(previous_position)
					iteration_count+=1
					if iteration_count % 3 == 0 and positions_history.size() > 0:
						for i in range(1,2):
							positions_history.remove_at(i)
					moved = true
					break
			if moved:
				break
