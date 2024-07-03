extends Control

@onready var my_slider := $VBoxContainer/testSlider
@onready var my_start_button := $VBoxContainer/startButton
@onready var cities_amt
@onready var file = FileAccess.open(ProjectSettings.globalize_path("res://") + "settings.txt", FileAccess.READ_WRITE)
@onready var closing = false

var Helvetica = preload("res://helvetica-255/Helvetica.ttf")
var defaultFontSize = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var img = Image.create(256, 256, false, Image.FORMAT_RGB8)
	img.fill(Color.RED)
	img.save_png("res://py_pics/saved_texture.png")
	$AnimationPlayer.play("OpeningAnimation") # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	closing = true
	$AnimationPlayer.play("OpeningAnimation", -1, 1.0, true)



func _on_timer_timeout():
	if(not closing):
		$AnimationPlayer.play("ScrollingText")
