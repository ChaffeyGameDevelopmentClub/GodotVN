extends Node2D

onready var choice_button = preload("res://Assets/Scenes/VisualNovel/ChoiceButton.tscn")
onready var choices = $CenterContainer/choices
signal event_complete
var last_choice = 0 #0 if no last choice has been made

signal save_choice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_choice(choice_list):
	var index = 1
	for choice in choice_list:
		var new_choice_button = choice_button.instance()
		new_choice_button.text = choice
		new_choice_button.connect("pressed", self, "button_pressed", [index])
		index += 1
		choices.add_child(new_choice_button)
		
func button_pressed(index):
	last_choice = index
	for choice in choices.get_children():
		choice.queue_free()
	emit_signal("event_complete")
	emit_signal("save_choice", index)
	
#Returns index of last choice, starting from one
func get_choice_index():
	return last_choice
