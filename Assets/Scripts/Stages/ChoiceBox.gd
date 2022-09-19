"""
ChoiceBox.gd is the script used by choice boxes whenever the player makes a decision. They support 
a variable number of choices. The ChoiceBox scene also relies on the ChoiceButton scene.
"""

extends Node2D

onready var choice_button = preload("res://Assets/Scenes/VisualNovel/ChoiceButton.tscn")
onready var choices = $CenterContainer/choices
var last_choice = 0 #0 if no last choice has been made

signal event_complete
signal save_choice #Tell's parent to save the choice made in StageData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Used to generate choices
func start_choice(choice_list):
	var index = 1
	for choice in choice_list:
		var new_choice_button = choice_button.instance()
		new_choice_button.text = choice
		new_choice_button.connect("pressed", self, "button_pressed", [index])
		index += 1
		choices.add_child(new_choice_button)

#Script that runs whenever the button is pressed.
func button_pressed(index):
	last_choice = index
	for choice in choices.get_children():
		choice.queue_free()
	emit_signal("event_complete")
	emit_signal("save_choice", index)
	
#Returns index of last choice, starting from one
func get_choice_index():
	return last_choice
