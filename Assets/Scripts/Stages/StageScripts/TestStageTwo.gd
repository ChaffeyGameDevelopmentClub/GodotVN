extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/VisualNovel/Actors/TestActor.tscn")

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
	set_transition_opacity(1)
	#Now we instance our actors.
	TestActor = TestActor.instance()
	
	#Now add them to scene tree
	Actors.add_child(TestActor)
	
	#Load the setting/environment.
	Setting.add_child(load("res://Assets/Scenes/VisualNovel/Settings/Complex_two.tscn").instance())
	
	#Now we do stage positions.
	TestActor.event_set_stage_position(Actor.STAGE_POSITION_LEFT)
	TestActor.event_flip_horizontal()
	
	.stage_init()

# Called when the node enters the scene tree for the first time.
func _ready():
	stage_init()

	event_script = [
		CustomEvent.new(self, funcref(self, "event_fade_in"), 1),
		DialogEvent.new(TestActor, "This is test stage two!"),
		ResponseEvent.new(TestActor, response_one, ["TestStageOne", 0]),
		ChoiceEvent.new(cb_one),
		ChoiceEvent.new(cb_one),
		CustomEvent.new(self, funcref(self, "event_fade_out"), 1),
		ChangeStageEvent.new("TestStageTwo")
		
	]
	
