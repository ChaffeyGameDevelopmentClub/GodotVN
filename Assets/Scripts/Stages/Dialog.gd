extends Control

"""
Dialog.gd is the script that controls dialog boxes. For an example of the dialog system, please see TestStage.tscn
"""


onready var ActorName = $VBoxContainer/HBoxContainer/ReferenceRect/ActorName
onready var DialogText = $VBoxContainer/DialogBox/CenterContainer/DialogText
onready var Pointer = $VBoxContainer/DialogBox/Pointer
onready var PointerAnimation = $VBoxContainer/DialogBox/Pointer/PointerAnimation
onready var BoxAnimator = $BoxAnimator
onready var TextSoundPlayer = $TextSoundPlayer

var velocity = 0 #Rate of text progression
export (float) var base_velocity = 0 #Starting velocity
var progress = 0 as float #Variable representing the progress from the start to the end of given dialog.

var current_dialog_complete
var visible_dialog
const CHARACTERS_PER_LINE = 40
var last_char_count = 0
var input_enabled = false

signal ready_for_new_dialog
var queuedDialog = []

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = base_velocity
	PointerAnimation.set("current_animation", "PointerAnimation")
	PointerAnimation.play()
	DialogText.get_child(0).rect_scale.x = 0
	DialogText.set("visible_characters", 0)

#Here we take incoming dialog and break it down into substrings.
func queueDialog(dialog: String):
	queuedDialog.clear()
	
	var current_index = 0 #Represents highest index inside a substring. Used to reinject bbcode.
	
	#A regex is used to extract any BBCode so it can be reinjected after creating substrings.
	var regex = RegEx.new()
	regex.compile("\\[(.*?)\\]")
	var bbcodes = regex.search_all(dialog)
	var bbcodes_adjusted_indexes = []
	bbcodes_adjusted_indexes.resize(len(bbcodes))
	
	for i in range(0, len(bbcodes)):
		if (i > 0):
			bbcodes_adjusted_indexes[i] = bbcodes[i].get_start() - (bbcodes[i-1].get_end() - bbcodes[i-1].get_start())
		else:
			bbcodes_adjusted_indexes[i] = bbcodes[i].get_start()
	
	dialog = regex.sub(dialog, "", true)
	
	#Now we create substrings.
	var lines = []
	while (len(dialog) > 0):
		var line = dialog.substr(0, CHARACTERS_PER_LINE)
		var re_insert_index = null
		if (len(line) == CHARACTERS_PER_LINE):
			if (dialog[CHARACTERS_PER_LINE-1] != " "):
				for i in range(len(line), 0, -1):
						if (dialog[i-1] == " "):
							re_insert_index = i
							break
		if (re_insert_index != null):
			var re_inserted = line.substr(re_insert_index, len(line))
			line.erase(re_insert_index, len(line))
			dialog.insert(0, re_inserted)
			dialog.erase(0, re_insert_index)
		else:
			dialog.erase(0, CHARACTERS_PER_LINE)
		lines.append(line)
		
	#There is a maximum of three substrings per page. 
	for _i in range(0, int(len(lines)/3)):
		var to_queue = (lines.pop_front() + lines.pop_front() + lines.pop_front())
		print(to_queue)
		
		current_index += len(to_queue)
		
#		for bbcode in bbcodes:
#			if bbcode.get_start() <= current_index:
#				to_queue = to_queue.insert(bbcodes_adjusted_indexes - (current_index - len(to_queue)), bbcode.get_string())
#				print(bbcode.get_start())
				
		for j in range(0, len(bbcodes)):
			if bbcodes[j].get_start() <= current_index:
				to_queue = to_queue.insert(bbcodes_adjusted_indexes[j] - (current_index - len(to_queue)), bbcodes[j].get_string())
		
		if (len(lines) > 0):
			if to_queue[len(to_queue)-1] == " ":
				to_queue.erase(len(to_queue)-1, len(to_queue))
			
			to_queue += "—"
		queuedDialog.append(to_queue)
		
	#Any leftovers get cleaned up.
	var remaining_lines = ""
	while (len(lines) > 0):
		remaining_lines += lines.pop_front()
	if (remaining_lines != ""):
		queuedDialog.append(remaining_lines)
	print(queuedDialog)
	
	#Now we animate the box upwards.
	BoxAnimator.set("current_animation", "BoxUp")

#Gets the current index of characters that are displayed.
func get_index():
	return int(progress)
	
#Set the name of the actor.
func set_actor_name(name: String):
	ActorName.text = name

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
		
	var delta_visible = velocity * delta
	progress += delta_visible
	progress = clamp(progress, 0, DialogText.get_total_character_count())
	DialogText.set("visible_characters", int(progress))
	if(get_index() > last_char_count):
		TextSoundPlayer.play()
		
	last_char_count = get_index()
	
	if (progress >=  DialogText.get_total_character_count()):
		PointerAnimation.play()
		if Input.is_action_just_pressed("Next_Dialog") and input_enabled:
			if len(queuedDialog) > 0:
				PointerAnimation.stop()
				PointerAnimation.play()
				DialogText.set_bbcode(queuedDialog.pop_front())
				DialogText.set("visible_characters", 0)
				progress = 0
			else:
				BoxAnimator.set("current_animation", "BoxDown")
				
	elif progress > (DialogText.get_total_character_count()/10) and Input.is_action_pressed("Next_Dialog") and input_enabled:
		velocity = base_velocity * 10
		pass
	else:
		velocity = base_velocity
		PointerAnimation.stop()
		
#The sound that plays for ever character that is displayed.
func set_text_sound(sound):
	TextSoundPlayer.set_stream(sound)

#When the dialog box is finished moving up or down, this function will run.
func _on_BoxAnimator_animation_finished(anim_name):
	if (anim_name == "BoxDown"):
		input_enabled = false
		emit_signal("ready_for_new_dialog")
		DialogText.set_bbcode("")
		DialogText.set("visible_characters", 0)
	elif (anim_name == "BoxUp"):
		if len(queuedDialog) > 0:
			PointerAnimation.stop()
			PointerAnimation.play()
			DialogText.set_bbcode(queuedDialog.pop_front())
			DialogText.set("visible_characters", 0)
			progress = 0
			input_enabled = true
