extends Node

var _internal_dialog_node_ref
var _internal_event_data_ref
var _internal_target_player_ref: AnimationPlayer


func handle_event(event_data, dialog_node):
	""" 
		If this event should wait for dialog advance to occur, uncomment the WAITING line
		If this event should block the dialog from continuing, uncomment the WAITINT_INPUT line
		While other states exist, they generally are not neccesary, but include IDLE, TYPING, and ANIMATING
	"""
	dialog_node.set_state(dialog_node.state.WAITING)
	#dialog_node.set_state(dialog_node.state.WAITING_INPUT)

	_internal_dialog_node_ref = dialog_node
	_internal_event_data_ref = event_data

	if event_data["play_animation"]["clear_text"]:
		_clear_text()

	if _internal_target_player_ref == null:
		_internal_target_player_ref = dialog_node.get_node_or_null(
			event_data["play_animation"]["target_node_path"]
		)

	if _internal_target_player_ref == null:
		dialog_node.dialog_script = {
			"events":
			[
				{},
				{
					"event_id": "dialogic_001",
					"character": "",
					"portrait": "",
					"text":
					(
						"[Dialogic Error] Calling Animation Player [color=red]"
						+ event_data["play_animation"]["target_node_path"]
						+ "[/color]. It seems like the object doesn't exist. Please ensure the NodePath is correct."
					)
				}
			]
		}
		_end_event()
		return

	if (
		_internal_target_player_ref.get_animation(event_data["play_animation"]["animation_name"])
		== null
	):
		dialog_node.dialog_script = {
			"events":
			[
				{},
				{
					"event_id": "dialogic_001",
					"character": "",
					"portrait": "",
					"text":
					(
						"[Dialogic Error] Playing Animation [color=red]"
						+ event_data["play_animation"]["animation_name"]
						+ "[/color]. It seems like the animation doesn't exist on the AnimationPlayer. Please ensure the name is correct."
					)
				}
			]
		}
		_end_event()
		return
	else:
		_internal_target_player_ref.play(event_data["play_animation"]["animation_name"])

	if event_data["play_animation"]["wait_until_finished"]:
		if !_internal_target_player_ref.is_connected(
			"animation_finished", self, "_on_target_player_animation_finished"
		):
			_internal_target_player_ref.connect(
				"animation_finished", self, "_on_target_player_animation_finished"
			)
	else:
		# once you want to continue with the next event
		_end_event()


# helpers
func _on_target_player_animation_finished(_anim_name: String):
	if _internal_event_data_ref["play_animation"]["wait_until_finished"]:
		_end_event()


func _clear_text():
	_internal_dialog_node_ref.get_node("TextBubble").visible = false
	_internal_dialog_node_ref.update_text("")


func _end_event():
	_internal_dialog_node_ref._load_next_event()
	_internal_dialog_node_ref.set_state(_internal_dialog_node_ref.state.READY)
	_internal_dialog_node_ref.get_node("TextBubble").visible = true
