tool
extends "res://addons/dialogic/Editor/Events/Parts/EventPart.gd"

# has an event_data variable that stores the current data!!!

## node references
onready var target_path_input = $Properties/TargetNodeEdit
onready var animation_name_input = $Properties/AnimationNameEdit
onready var wait_until_finished = $Properties/WaitCheckBox
onready var clear_text = $Properties/ClearTextCheckBox


# used to connect the signals
func _ready():
	target_path_input.connect("text_changed", self, "_on_TargetPathInput_text_changed")
	animation_name_input.connect("text_changed", self, "_on_AnimationName_text_changed")
	wait_until_finished.connect("toggled", self, "_on_WaitCheckbox_toggled")
	clear_text.connect("toggled", self, "_on_ClearTextCheckbox_toggled")


# called by the event block
func load_data(data: Dictionary):
	# First set the event_data
	.load_data(data)

	# Now update the ui nodes to display the data.
	target_path_input.text = event_data["play_animation"]["target_node_path"]
	animation_name_input.text = event_data["play_animation"]["animation_name"]

	wait_until_finished.pressed = event_data["play_animation"]["wait_until_finished"]
	clear_text.pressed = event_data["play_animation"]["clear_text"]


# has to return the wanted preview, only useful for body parts
func get_preview():
	if (
		event_data["play_animation"]["target_node_path"]
		and event_data["play_animation"]["animation_name"]
	):
		return (
			"Plays `"
			+ event_data["play_animation"]["animation_name"]
			+ "` on Animation Player `"
			+ event_data["play_animation"]["target_node_path"]
		)
	else:
		return ""


func _on_TargetPathInput_text_changed(text):
	event_data["play_animation"]["target_node_path"] = text

	# informs the parent about the changes!
	data_changed()


func _on_AnimationName_text_changed(text):
	event_data["play_animation"]["animation_name"] = text

	# informs the parent about the changes!
	data_changed()


func _on_WaitCheckbox_toggled(button_pressed):
	event_data["play_animation"]["wait_until_finished"] = button_pressed

	# informs the parent about the changes!
	data_changed()


func _on_ClearTextCheckbox_toggled(button_pressed):
	event_data["play_animation"]["clear_text"] = button_pressed

	# informs the parent about the changes!
	data_changed()
