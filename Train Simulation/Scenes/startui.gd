extends Control

#settings values
@onready var cities_amt: int
@onready var noiseSeed: int
@onready var waterLevel: float
@onready var noiseScale: int
@onready var octaves: int
@onready var lacunarity: int

var mouseArrow = load("res://UISprite/minimal-gear-pack.png")
var mouseOther = load("res://UISprite/gearMouse.png")


@onready var SAVE_PATH: String = "user://settings.bin"
@onready var LOAD_INFO_PATH: String = "user://loadingCommunication.bin"

#utility
@onready var closing = false

var Helvetica = preload("res://helvetica-255/Helvetica.ttf")
var defaultFontSize = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_custom_mouse_cursor(mouseArrow)
	#Input.set_custom_mouse_cursor(mouseOther, Input.CURSOR_IBEAM)
	#Input.set_custom_mouse_cursor(mouseOther, Input.CURSOR_BUSY)
	#var img = Image.create(256, 256, false, Image.FORMAT_RGB8)
	#img.fill(Color.RED)
	#img.save_png("res://py_pics/saved_texture.png")
	$AnimationPlayer.play("OpeningAnimation") # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	closing = true
	
#region Assigning Input Variables
	cities_amt = int($numOfCitiesSlider.value)
	
	if($Panel/ColorRect/VBoxContainer/seedInput_text.text == ""):
		noiseSeed = randi_range(0, 400)
	else:
		noiseSeed = int($Panel/ColorRect/VBoxContainer/seedInput_text.text)

	if($Panel/ColorRect/VBoxContainer/HBoxContainer/waterHeight_text.text == ""):
		waterLevel = -0.07
	else:
		waterLevel = float($Panel/ColorRect/VBoxContainer/HBoxContainer/waterHeight_text.text)
	
	if($Panel/ColorRect/VBoxContainer/HBoxContainer2/noiseScale_text.text == ""):
		noiseScale = 200
	else:
		noiseScale = int($Panel/ColorRect/VBoxContainer/HBoxContainer2/noiseScale_text.text)
	if($Panel/ColorRect/VBoxContainer/HBoxContainer2/octaves_text.text == ""):
		octaves = 6
	else:
		octaves = int($Panel/ColorRect/VBoxContainer/HBoxContainer2/octaves_text.text)
		
	if($Panel/ColorRect/VBoxContainer/HBoxContainer2/lacunarity_text.text == ""):
		lacunarity = 2.0
	else:
		lacunarity = float($Panel/ColorRect/VBoxContainer/HBoxContainer2/lacunarity_text.text)
#endregion

#region Writing to a File (.bin)	
	
	var information = {
		cities_amt = self.cities_amt,
		seed = self.noiseSeed,
		waterLevel = self.waterLevel,
		noiseScale = self.noiseScale,
		octaves = self.octaves,
		lacunarity = self.lacunarity
	}
	
	var jstr = JSON.stringify(information)
	print(str(ProjectSettings.globalize_path(SAVE_PATH)))
	FileAccess.open(ProjectSettings.globalize_path(SAVE_PATH), FileAccess.WRITE).store_line(jstr)
	
	var loadingInfo = {
		loadingProgress = 1
	}
	
	jstr = JSON.stringify(loadingInfo)
	print(str(ProjectSettings.globalize_path(LOAD_INFO_PATH)))
	FileAccess.open(ProjectSettings.globalize_path(LOAD_INFO_PATH), FileAccess.WRITE).store_line(jstr)
	
	$AnimationPlayer.play("closing_Animations")
	
	$closingTimer.start()
#endregion



func _on_timer_timeout():
	if(not closing):
		$AnimationPlayer.play("ScrollingText")


func _on_closing_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/loadingScreen.tscn")

