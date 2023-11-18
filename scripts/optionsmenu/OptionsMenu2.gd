extends Node2D

onready var ControlModeButton = $OptionsUI/MenuVBox/ControlMode
onready var ScoreboardManager = $ScoreboardManager
onready var ResetScoreboardButton = $OptionsUI/MenuVBox/ResetScoreboard

func _on_OptionsUI_button_pressed(buttonName:String):
	match(buttonName):
		"Return":
			get_tree().change_scene_to(Global.MainMenuScene)
		"ControlMode":
			toggle_controlmode()
		"ToggleFullscreen":
			toggle_fullscreen()
		"ResetScoreboard":
			reset_scoreboard()
		_:
			print("No matching line for: "+buttonName)

func toggle_fullscreen():
	Global.bFullscreen = !Global.bFullscreen
	OS.set_window_fullscreen(Global.bFullscreen)

func toggle_controlmode():
	match(Global.cControlMode):
		Global.eControlMode.eightway:
			ControlModeButton.text = "Control Mode: Rotate"
			Global.cControlMode = Global.eControlMode.rotate
		Global.eControlMode.rotate:
			ControlModeButton.text = "Control Mode: 8-Way"
			Global.cControlMode = Global.eControlMode.eightway

func reset_scoreboard():
	ResetScoreboardButton.text = "Scoreboard Reset!"
	ScoreboardManager.reset_scoreboard()
