extends Event

class_name CustomEvent
var _funcv = null #variable func
var _obj = null #object we yield to
var _args = null #arguments for variable func

func _init(obj, funcv, args):
	if not typeof(args) == TYPE_ARRAY:
		args = [args] #something tells me this looks confusing without context.
					  #basically, call_funcv requires an array. This ensures we always have an array.
		
	type = EventType.CUSTOM
	_funcv = funcv
	_obj = obj
	_args = args
	
func start_event():
	_funcv.call_funcv(_args)
	yield(_obj, "event_complete")
	emit_signal("event_complete")
	
