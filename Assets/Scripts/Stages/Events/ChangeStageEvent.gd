extends Event

class_name ChangeStageEvent
var _stage_name = null

signal change_stage()

func _init(stage_name):
	type = EventType.CHANGESTAGE
	_stage_name = stage_name
	
func start_event():
	emit_signal("change_stage", _stage_name)
	
