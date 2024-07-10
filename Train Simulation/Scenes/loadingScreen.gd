extends Control
#@onready var LOAD_INFO_PATH: String = "user://loadingCommunication.bin"
@onready var proceduralRailsStarted = false
@onready var mapLoading = false
@onready var _progress: Array = []
@onready var loadedLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("C:/Python311/python.exe " + "\"" + ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py" + "\"")
	#print(OS.execute("C:/Python311/python.exe", [ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py"]))
	#OS.create_process("CMD.exe", ["/C", "C:/Python311/python.exe " + ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py"])
	#print("executing")
	
	#OS.create_process("c:\\winnt\\system32\\cmd.exe", [])
	$AnimationPlayer.play("RESET")
	$ColorRect/VBoxContainer/HBoxContainer/LoadingBar.goalPercent = 100
	$ColorRect/VBoxContainer/HBoxContainer2/Label.text = "Loading..."
	

func _on_loading_bar_value_changed(value):
	if(value >= 100):
		#$AnimationPlayer.play("closing_animation")
		#$closingTimer.start()
		
		get_tree().change_scene_to_file("res://Scenes/tilemap_scene.tscn")


func _on_closing_timer_timeout():
	print("loading level...")
	get_tree().change_scene_to_packed(loadedLevel)
	print("level loaded!")
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request("res://Scenes/tilemap_scene.tscn", "", true)
	if state == OK:
		mapLoading = true
	
	
