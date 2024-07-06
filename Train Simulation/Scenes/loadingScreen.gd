extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("C:/Python311/python.exe " + "\"" + ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py" + "\"")
	#print(OS.execute("C:/Python311/python.exe", [ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py"]))
	#OS.create_process("CMD.exe", ["/C", "C:/Python311/python.exe " + ProjectSettings.globalize_path("res://Python/image_generation/") + "terrainGeneration.py"])
	#print("executing")
	
	OS.create_process("c:\\winnt\\system32\\cmd.exe", [])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var communication = FileAccess.open("res://Python/loadingCommunication.txt", FileAccess.READ)
	var communicationText = communication.get_as_text()
	communication.close()
	
	var goal = 0
	
	match len(communicationText):
		0:
			goal = 0
		1:
			goal = 5
		2:
			goal = 10
		3:
			goal = 19
		4:
			goal = 25
		5:
			goal = 33
	
	$ColorRect/VBoxContainer/HBoxContainer/LoadingBar.goalPercent = goal

func _on_loading_bar_value_changed(value):
	if(value >= 100):
		$AnimationPlayer.play("closing_animation")
		$closingTimer.start()


func _on_closing_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/generator.tscn")
