extends Control

@onready var my_slider := $VBoxContainer/testSlider
@onready var my_start_button := $VBoxContainer/startButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("OpeningAnimation") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_test_slider_value_changed(value):
	#placeholder for on value change
	print("The value has been changed to ",value, " cities.")
	
func _on_test_slider_drag_ended(value_changed):
	#possible place to execute something once user is finished
	#changing a value
	pass # Replace with function body.


func _on_start_button_pressed():
	var file = FileAccess.open(ProjectSettings.globalize_path("res://") + "settings.txt", FileAccess.WRITE)
	file.store_var("hello world")
	file = null
	#export user generation preferences

