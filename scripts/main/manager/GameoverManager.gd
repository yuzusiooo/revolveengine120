extends Node2D

onready var FinalScoreUI = $FinalScoreUI

signal recieved_finalscore(newScore)

func _on_TimerManager_timeLimit_met():
	gameover()
	set_FinalScore_UI()

func gameover():
	Global.Main.gameStarted = false

func set_FinalScore_UI():
	var scoreStats = Global.Main.ScoreManager.get_scoreStats()
	var playerLives = Global.Main.Player.get_hp()
	Global.Main.HUD.set_UI(false)
	FinalScoreUI.calculate_finalScore(scoreStats[0], playerLives, scoreStats[1])
	FinalScoreUI.set_UI(true)
	emit_signal("recieved_finalscore", FinalScoreUI.finalScore)
