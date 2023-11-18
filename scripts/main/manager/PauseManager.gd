extends Node

var bPaused:bool = false setget set_bPaused
onready var PauseUI = $PauseUI

func _unhandled_input(event):
	if (event.is_action_pressed("key_escape")):
		self.bPaused = !bPaused

func set_bPaused(value:bool):
	bPaused = value
	PauseUI.set_UI(value)
	Global.Main.HUD.set_UI(!value)
	get_tree().paused = bPaused


func _on_PauseUI_resume_pressed():
	set_bPaused(false)

func _on_PauseUI_quit_pressed():
	get_tree().paused = false
	Global.Main.return_Menu()


func _on_PauseUI_restart_pressed():
	get_tree().paused = false
	Global.Main.replay_game()
