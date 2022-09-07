extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/VisualNovel/Actors/TestActor.tscn")

#Now we define our choices
var choice_one = [
	"What was that for?",
	"You are a nerd!",
	"No u"
]

#Now we overload the stage init
func stage_init():
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
	.stage_init()

# Called when the node enters the scene tree for the first time.
func _ready():
	stage_init()
	
	#Format as funcref, speaker, then dialog.
	event_script = [
		[funcref(TestActor, "start_dialog"), TestActor, "This is just meant as a quick demo of this visual novel system. Ideally we will add more functionality later"],
		[funcref(ChoiceBox, "start_choice"), ChoiceBox, ["Okay?", "I don't care.", "Go commit die."]],
		[TestActor, choice_one],
	]
