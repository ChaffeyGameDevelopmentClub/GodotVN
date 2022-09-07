extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/VisualNovel/Actors/TestActor.tscn")

#Helper vars
var last_choice = 0

signal stage_loaded

# Called when the node enters the scene tree for the first time.
func _ready():
	#Now we instance our actors.
	TestActor = TestActor.instance()
	
	#Now add them to scene tree
	Actors.add_child(TestActor)
	
	#Load the setting/environment.
	Setting.add_child(load("res://Assets/Scenes/VisualNovel/Settings/YoukaiMountainLake.tscn").instance())
	
	#Now we do stage positions.
	TestActor.set_stage_position(Actor.STAGE_POSITION_LEFT)
	yield(TestActor, "finished_action") #Yield to wait until moving is done.
	TestActor.flip_horizontal()
	
	#Emit a signal so other nodes know we are ready
	emit_signal("stage_loaded")
	
	TestActor.start_dialog("This is just meant as a quick demo of this visual novel system. Ideally we will add more functionality later")
	yield(TestActor, "finished_action")
	
	ChoiceBox.start_choice(["Okay?", "I don't care.", "Go commit die."]) 
	yield(ChoiceBox, "choice_complete")
	
	last_choice = ChoiceBox.get_choice_index()
	
	match last_choice:
		1:
			TestActor.start_dialog("What do you mean okay?")
			yield(TestActor, "finished_action")
		2: 
			TestActor.start_dialog("Well that's not my problem.")
			yield(TestActor, "finished_action")
		3:
			TestActor.start_dialog("Well, that was just rude. Just close the game then... jerk.")
			yield(TestActor, "finished_action")
	
	
	
	

