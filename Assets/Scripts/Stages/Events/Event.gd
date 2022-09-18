extends Node
class_name Event

#Event type enumerates the different possible events
enum EventType {
	DIALOG, #Event where an actor speaks
	RESPONSE, #Event where an actor speaks in response to a choice
	CHOICE, #Event where the player makes a choice
	CONDITIONAL,
	CUSTOM_EVENT, #Custom scripted event
#	CHOICE_RESPONSE,
#	SETTING_TRANSITION,
#	STAGE_TRANSITION,
}

var type = null

signal event_complete

func _init():
	pass

func start_event():
	emit_signal("event_complete")

func free_event():
	self.queue_free()
