extends ProgressBar

@onready var goalPercent = 25
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(value < goalPercent):
		value += 0.5
