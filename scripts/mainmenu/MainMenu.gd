extends Node2D

# Scoreboard manager
onready var ScoreboardManager = $ScoreboardManager

# Title
onready var Title_VersionNumber = $Control/CanvasLayer/Title/VersionNumber
var versionNumberFormat = "%s\nDiskmachine 2022"

# Menu UI
onready var MenuUI = $Control/CanvasLayer/MenuUI

# Scoreboard
onready var HighscoreRecord = $Control/CanvasLayer/HighscoreRecord


func _ready():
	Title_VersionNumber.text = versionNumberFormat % Global.Game_Version
	load_scoreboard()
	if (MusicPlayer.currentMusic != "Menu"):
		MusicPlayer.play_music("Menu")

func _process(delta):
	MenuUI.process_descriptor(delta)

func load_scoreboard():
	ScoreboardManager.validate_scoreboard()
	HighscoreRecord.update_highscoreRecord(ScoreboardManager.get_scoreboard())

# func _on_MenuUI_PlayButton_pressed():
# 	get_tree().change_scene_to(Global.MainGameScene)

# func _on_MenuUI_OptionsButton_pressed():
# 	get_tree().change_scene_to(Global.OptionsScene)

# func _on_MenuUI_ReadMe_pressed():
# 	get_tree().change_scene_to(Global.ReadMeScene)


func _on_MenuUI_button_pressed(buttonName:String):
	match(buttonName):
		"PlayButton":
			get_tree().change_scene_to(Global.MainGameScene)
		"ReadMeButton":
			get_tree().change_scene_to(Global.ReadMeScene)
		"QuitButton":
			get_tree().quit()
		"OptionsButton":
			get_tree().change_scene_to(Global.OptionsScene)
		_:
			print("No matching line for: "+buttonName)
