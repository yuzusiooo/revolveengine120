extends Control

onready var CanvasLayer = $CanvasLayer

# score calculation
onready var BaseScore_Label = $CanvasLayer/ScoreBG/ScoreCalc/BaseScore/Label
onready var LifeBonus_Label = $CanvasLayer/ScoreBG/ScoreCalc/LifeBonus/Label
onready var MultiBonus_Label = $CanvasLayer/ScoreBG/ScoreCalc/MultiBonus/Label

# total score
onready var FinalScore_Label = $CanvasLayer/ScoreBG/FinalScore/Label

# sound
onready var ButtonSound = $ButtonSound
export var sndSelect:AudioStream
export var sndPress:AudioStream

signal replay_game
signal return_to_menu

var precalcScore = []
var finalScore:float

func calculate_finalScore(baseScore:float, livesLeft:float, maxMultiplier:float):
	precalcScore = [baseScore, livesLeft, maxMultiplier]
	finalScore = baseScore * (1 + (livesLeft * 0.1) -0.1) * (1 + (maxMultiplier * 0.1) - 0.1)

func set_UI(bOn:bool):
	CanvasLayer.visible = bOn
	$CanvasLayer/ScoreBG/SelectUI/ReplayButton.grab_focus()
	# setting UI text
	BaseScore_Label.text = String(precalcScore[0])
	LifeBonus_Label.text = String(1 + precalcScore[1] * 0.1 - 0.1)
	MultiBonus_Label.text = String(1 + precalcScore[2] * 0.1 - 0.1)
	FinalScore_Label.text = get_formattedFinalScore(finalScore)

func get_formattedFinalScore(finalScore):
	# finalScore in String format
	finalScore = String(finalScore)
	# size of the string
	var size = finalScore.length()
	# formatted text to be returned
	var formatted:String = ""
	for i in range(size):
		# if remainder of i%3 is 0 (ie this is the 3rd digit)
		if ((size - i) % 3 == 0 and i > 0):
			# add a comma to formatted
			formatted += ","
		# add digit at position i
		formatted += finalScore[i]
	return formatted

func _on_ReplayButton_pressed():
	button_pressed()
	emit_signal("replay_game")

func _on_ReturnButton_pressed():
	button_pressed()
	emit_signal("return_to_menu")

func _on_SendFeedbackButton_pressed():
	button_pressed()
	Global.send_feedback()

func button_focus_entered():
	ButtonSound.stream = sndSelect
	ButtonSound.play(0.0)

func button_pressed():
	ButtonSound.stream = sndPress
	ButtonSound.play(0.0)
