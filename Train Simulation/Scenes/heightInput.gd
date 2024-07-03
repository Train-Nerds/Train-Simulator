extends LineEdit
#variable to track the text
@onready var oldText = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_text_submitted(new_text):
	if(float(new_text) == 0 or float(self.text + new_text) > -0.07 or float(self.text + new_text) < 0):
		self.text = oldText
		print("text fail.")
	else:
		print("text succeed")
	oldText = self.text
