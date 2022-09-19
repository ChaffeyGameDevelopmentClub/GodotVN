extends Event

class_name ConditionalEvent
var _event #event that occurs per condition
var _condition #condition (choice) [stage_name, choice_number, choice]
signal add_event

func _init(event, condition):
	_event = event
	_condition = condition
	type = EventType.CONDITIONAL
	
func start_event():
	var target_stage = _condition[0]
	var target_choice_number = _condition[1]
	var target_choice = _condition[2]
	var choices = StageData.get_stage_choices(target_stage)
	if choices[target_choice_number] == target_choice:
		emit_signal("add_event", _event)
	return choices[target_choice_number] == target_choice
		
	
	
