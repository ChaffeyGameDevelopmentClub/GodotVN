extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/Stages/Actors/TestActor.tscn")

signal stage_loaded


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Now we instance our actors.
	TestActor = TestActor.instance()
	
	#Now add them to scene tree
	Actors.add_child(TestActor)
	
	#Load the setting/environment.
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/YoukaiMountainLake.tscn").instance())
	
	#Now we do stage positions.
	TestActor.set_stage_position(Actor.STAGE_POSITION_LEFT)
	yield(TestActor, "finished_action") #Yield to wait until moving is done.
	TestActor.flip_horizontal()
	
	#Emit a signal so other nodes know we are ready
	emit_signal("stage_loaded")
	
	#Now we start the scene!
	TestActor.start_dialog("Hello. I am an actor! I can talk and keep on talking. Wow, isn't talking just so... I don't know? Something? Who knows. Life is weird. ")
	yield(TestActor, "finished_action")
	TestActor.start_dialog("This is just meant as a quick demo of this visual novel system. Ideally we will add more functionality later")
	yield(TestActor, "finished_action")
	
	

