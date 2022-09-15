extends Event


class_name ChoiceEvent

var choice_box = null
var _choices = null

func _init(choices):
	type = EventType.CHOICE
	_choices = choices

func start_event():
	choice_box.start_choice(_choices)
