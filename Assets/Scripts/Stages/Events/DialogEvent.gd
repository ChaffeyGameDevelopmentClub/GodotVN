extends Event

class_name DialogEvent
var _actor = null
var _dialog = null

func _init(actor, dialog):
	type = EventType.DIALOG
	_actor = actor
	_dialog = dialog
	#event = funcref(self, "dialog_event")
	
func start_event():
	_actor.start_dialog(_dialog)
	
