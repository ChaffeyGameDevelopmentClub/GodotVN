extends Node2D

"""
Actor.gd is the script that controls "Actors", specifically charcters that can deliver dialogue in a cutscene type prompt.
Use scene inheritance to utilize the scene associated with this script.
"""

class_name Actor

onready var Pose = $Pose
onready var m_dialog
onready var StagePositionTween = $StagePositionTween
export (String) var actor_name
signal event_complete
signal start_dialog

enum {
	STAGE_POSITION_LEFT = 360, #Left
	STAGE_POSITION_ZERO = 960, #Center, Phanta will kill any who change the name
	STAGE_POSITION_RIGHT = 1560 #Right
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_pose(pose: int):
	Pose.set("frame", pose)

#Set the position of the actor. Pass enums such as STAGE_POSITION_ZERO
func set_stage_position(stage_position: float):
#	var target = Vector2(stage_position, Pose.position.y)
#	StagePositionTween.interpolate_property(Pose, "position:x", Pose.position.x, stage_position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	StagePositionTween.start()
	Pose.position.x = stage_position

#Start dialog for the dialog box.
func start_dialog(dialog: String):
	emit_signal("start_dialog", actor_name, dialog)
	
#Flip the actor horizontally.
func flip_horizontal():
	Pose.set("flip_h", not Pose.get("flip_h"))
	
func _process(delta):
	pass
