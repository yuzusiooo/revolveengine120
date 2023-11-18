extends Node2D

onready var ScoreboardManager = $ScoreboardManager

func _ready():
	$Control/CanvasLayer/Navigation/ReturnButton.grab_focus()

func _on_ResetScoreboardButton_pressed():
	ScoreboardManager.reset_scoreboard()

func _on_SendFeedbackButton_pressed():
	Global.send_feedback()

func _on_ReturnButton_pressed():
	get_tree().change_scene_to(Global.MainMenuScene)
