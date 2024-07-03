extends LineEdit

@onready var oldText = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_submitted(new_text):
	if(int(new_text) == 0 or int(self.text + new_text) > 400 or int(self.text + new_text) < 0):
		self.text = oldText
		print("text fail.")
	else:
		print("text succeed")
	oldText = self.text
