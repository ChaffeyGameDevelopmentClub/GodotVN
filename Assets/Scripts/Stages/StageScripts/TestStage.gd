extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/VisualNovel/Actors/TestActor.tscn")
var loading_state = false

#Now we define our choices
var cb_one = [
	"Okay?", 
	"I don't care.", 
	"Go commit die."
]

#Now we define our responses
var response_one = [
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
	TestActor.flip_horizontal()
	
	.stage_init()

# Called when the node enters the scene tree for the first time.
func _ready():
	stage_init()

	#Format as funcref, event type, then dialog.
	event_script = [
		[funcref(TestActor, "start_dialog"), Dialog, "I am going to start typing this. This is another cool sentence, capiche?"],
		[funcref(ChoiceBox, "start_choice"), ChoiceBox, cb_one],
		[TestActor, response_one],
		[funcref(TestActor, "start_dialog"), Dialog, "Statement 2, event 4"],
		[TestActor, response_one],
		[funcref(TestActor, "start_dialog"), Dialog, "Statement 3"],
		[funcref(TestActor, "start_dialog"), Dialog, "Statement 4"],
	]
