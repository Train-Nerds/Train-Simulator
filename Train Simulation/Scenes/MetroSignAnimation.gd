extends Label

@onready var flipFlop = true
@onready var givingInstructions = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_timer_timeout():
	var rand = randi_range(0, 9)
	if(flipFlop):
		rand = 10
	var newText = ""
	match rand:
		0:
			newText = "breaking news: cat 5 hurricane in Utah."
		1:
			newText = "Canadian meese mourn the death of their leader today."
		2:
			newText = "Lakeside geese are caught sleeping by students."
		3:
			newText = "\"It wasn't me,\" Mr. Snake pleas."
		4:
			newText = "breaking news: German trains are never on time."
		5:
			newText = "is marta your love? find out today!"
		6:
			newText = "trainerds ltd. stock up 5,000% this quarter!"
		7:
			newText = "Singer MafuMafu rises to the world stage"
		8:
			newText = "ghp government passes bill; $400 fine for unmade beds."
		9:
			newText = "Sir Brisaac issues edict of permanent strikes to criminals."
		10:
			newText = "To continue, please press the arrow button -->"
	
	flipFlop = not flipFlop
	text = newText
	
