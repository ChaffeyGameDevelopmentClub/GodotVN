extends Node2D


onready var stage = $Stage


# Called when the node enters the scene tree for the first time.
func _ready():
	stage.load_stage_state([4, 2])
