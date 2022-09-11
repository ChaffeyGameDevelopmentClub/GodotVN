extends Event

class_name ResponseEvent

var _actor = null
var _dialog_responses = null #list of responses
var _choice_condition #the choice being responded to [stage_name, choice number]
onready var stage_data

func _init(actor, dialog_responses, choice_condition):
	type = EventType.DIALOG
	_actor = actor
	_dialog_responses = dialog_responses
	_choice_condition = choice_condition
	
func start_event():
	var choice = StageData.get_stage_choices(_choice_condition[0])[_choice_condition[1]]
	_actor.start_dialog(_dialog_responses[choice-1])
