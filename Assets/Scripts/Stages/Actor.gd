extends Node2D

"""
Actor.gd is the script that controls "Actors", specifically charcters that can deliver dialogue in a cutscene type prompt.
Use scene inheritance to utilize the scene associated with this script. This means inheriting from Actor.tscn, not Actor.gd.
"""

class_name Actor

onready var Pose = $Pose
onready var StagePositionTween = $StagePositionTween
onready var ActorTransitionTween = $ActorTransitionTween
export (String) var actor_name #The actor's name. This is to be set in the inherited scene within the editor, not within script.
export (Color) var dialog_color
signal event_complete
signal start_dialog

#Enums for preset stage_positions, in pixel coordinates.
enum {
	STAGE_POSITION_LEFT = 360, #Left
	STAGE_POSITION_ZERO = 960, #Center
	STAGE_POSITION_RIGHT = 1560 #Right
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Set the actor's current pose/expression.
func set_pose(pose: int):
	Pose.set("frame", pose)
	yield(get_tree().create_timer(0.001), 'timeout') #WOOOOO THIS IS SKETCHY
	call_deferred("emit_signal", "event_complete")

#Set the position of the actor. Pass enums such as STAGE_POSITION_ZERO, or the position in pixel coordinates.
func event_set_stage_position(stage_position: float):
	Pose.position.x = stage_position
	call_deferred("emit_signal", "event_complete")

func event_fade_in(f_speed: float):
	ActorTransitionTween.interpolate_property(Pose, "modulate:a", 0, 1, f_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	ActorTransitionTween.start()
	yield(ActorTransitionTween, "tween_completed")
	call_deferred("emit_signal", "event_complete")

func event_fade_out(f_speed: float):
	ActorTransitionTween.interpolate_property(Pose, "modulate:a", 1, 0, f_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	ActorTransitionTween.start()
	yield(ActorTransitionTween, "tween_completed")
	call_deferred("emit_signal", "event_complete")

func event_set_opacity(opacity):
	Pose.modulate.a = opacity

func event_lerp_stage_position(stage_position):
	var target = Vector2(stage_position, Pose.position.y)
	StagePositionTween.interpolate_property(Pose, "position:x", Pose.position.x, stage_position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	StagePositionTween.start()
	yield(StagePositionTween, "tween_completed")
	call_deferred("emit_signal", "event_complete")

#Start the actor's dialog so that the actor is speaking. This emits a signal to the dialog box 
#assuming the actor is binded to the box via the connect function.
func start_dialog(dialog: String):
	emit_signal("start_dialog", actor_name, dialog_color, dialog)
	
#Flip the actor horizontally.
func event_flip_horizontal():
	Pose.set("flip_h", not Pose.get("flip_h"))
	yield(get_tree().create_timer(0.001), 'timeout')
	call_deferred("emit_signal", "event_complete")
	

