"""
CustomEvent

Custom events are used to wrap function/object pairs using funcrefs. 

For the constructor, obj must be the object we yield on, funcv must be a funcref to our function of 
interest, and args must be an array of arguments supplied to the given function. 

When designing a function to be used with CustomEvent, it is HIGHLY ADVISED
that you use call_deferred("emit_signal", <signal_name>) as opposed to the
emit_signal function. 

"""
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
	
