extends Event

class_name TimedActorEvent #Displays an image actor for a duration of time
var _stage = null
var _actor = null
var _position = null
var _time = null


func _init(stage, actor, position, time):
	type = EventType.CUSTOM
	_actor = actor
	_stage = stage
	_position = position
	_time = time


func start_event():
	_actor = _actor.instance() # instantiates the preload actor argument
	_stage.get_node("Actors").add_child(_actor) # adds the image actor to the scene tree
	_actor.event_set_stage_position(_position) # sets image actor position
	
	yield(_stage.get_tree().create_timer(_time), "timeout") # timer before image actor dissapears
	_actor.queue_free()
	#_actor.modulate.a = 0
	emit_signal("event_complete")
