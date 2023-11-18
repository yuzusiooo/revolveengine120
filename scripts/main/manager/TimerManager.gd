extends Node2D

export var timeLimit:float = 120
var currentTime:float = 0

var timeLeft_format:String = "%0*.*f"


signal timeLimit_met

func _physics_process(delta):
	if (Global.Main.gameStarted):
		if (currentTime >= timeLimit):
			emit_signal("timeLimit_met")
			return
		currentTime += delta
		# get the current time left as a formatted string
		var timeLeft_String:String = timeLeft_format % [5, 2, (timeLimit - currentTime)]
		Global.Main.HUD.set_TimeLeft(timeLeft_String)
