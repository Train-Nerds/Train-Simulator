extends Control
@onready var LOAD_INFO_PATH: String = "user://loadingCommunication.bin"
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var communication = FileAccess.open("user://loadingCommunication.bin", FileAccess.READ)
	var communicationText = communication.get_as_text()
	var loadingInfo = JSON.new()
	var error = loadingInfo.parse(communicationText)

	communication.close()
	
	#print(loadingInfo.data)
	var goal = 0
	var loadingText = "Loading..."

	
	#print(loadingInfo.data['loadingProgress'])
	print(typeof(loadingInfo.data['loadingProgress']))
	
	match loadingInfo.data['loadingProgress']:
		0.0:
			goal = 0
			loadingText = "Generating Terrain..."
			#print("Goal is 0")
		1.0:
			goal = 5
			#print("Goal is 5")
			loadingText = "Generating Terrain..."
		2.0:
			goal = 10
			loadingText = "Generating Terrain..."
		3.0:
			goal = 19
			loadingText = "Generating Terrain..."
		4.0:
			goal = 45
			loadingText = "Procedurally Generating Rails..."
			if(not proceduralRailsStarted):
				var proceduralScript = preload("res://Scenes/generator.gd").new()
				proceduralScript.run("res://informationMap.png", "user://proceduralRailOutput.png")
				var loadingInfoDef = {
					loadingProgress = 5
				}
	
				var jstr = "{\"loadingProgress\": 5}"
				print(str(ProjectSettings.globalize_path(LOAD_INFO_PATH)))
				FileAccess.open(ProjectSettings.globalize_path(LOAD_INFO_PATH), FileAccess.WRITE).store_line(jstr)
			
		5.0:
			goal = 60
			loadingText = "AI is Generating Rails..."
		6.0:
			goal = 80
			loadingText = "Loading Level!"
			
			if(not mapLoading):
				start_load()
			else:
				var load_status = ResourceLoader.load_threaded_get_status("res://Scenes/tilemap_scene.tscn")
				match load_status:
					0, 2:
						mapLoading = false
					3:
						print("Level Loaded")
						loadedLevel = ResourceLoader.load_threaded_get("res://Scenes/tilemap_scene.tscn")
						
						var jstr = "{\"loadingProgress\": 7}"
						FileAccess.open(ProjectSettings.globalize_path(LOAD_INFO_PATH), FileAccess.WRITE).store_line(jstr)
					_:
						print("Still loading")
		7.0:
			goal = 100
			loadingText = "Level loaded!"
			
		_:
			#print("None")
			pass
	
	$ColorRect/VBoxContainer/HBoxContainer/LoadingBar.goalPercent = goal
	$ColorRect/VBoxContainer/HBoxContainer2/Label.text = loadingText

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
	
	
