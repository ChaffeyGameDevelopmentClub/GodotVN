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
	Setting.add_child(load("res://Assets/Scenes/VisualNovel/Settings/Complex_One.tscn").instance())
	
	#Now we do stage positions.
	TestActor.event_set_stage_position(Actor.STAGE_POSITION_LEFT)
	TestActor.event_flip_horizontal()
	TestActor.event_set_opacity(0)
	
	.stage_init()

# Called when the node enters the scene tree for the first time.
func _ready():
	stage_init()

	event_script = [
		CustomEvent.new(self, funcref(self, "event_fade_in"), 1),
		CustomEvent.new(TestActor, funcref(TestActor, "event_fade_in"),  1),
		DialogEvent.new(TestActor, "I am going to start typing this. This is another cool sentence, capiche?"),
		ChoiceEvent.new(cb_one),
		CustomEvent.new(TestActor, funcref(TestActor, "event_lerp_stage_position"), 1000),
		ResponseEvent.new(TestActor, response_one, [stage_name, 0]),
		ConditionalEvent.new(DialogEvent.new(TestActor, "This is a conditional event"), [stage_name, 0, 1]),
		DialogEvent.new(TestActor, "More dialog testing"),
		CustomEvent.new(self, funcref(self, "event_fade_out"), 1),
		ConditionalEvent.new(ChangeStageEvent.new("TestStageTwo"), [stage_name, 0, 1]),
	]
	
