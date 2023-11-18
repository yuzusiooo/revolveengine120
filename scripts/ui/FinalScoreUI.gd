extends Control

onready var CanvasLayer = $CanvasLayer

onready var ScoreCalculation = $CanvasLayer/ScoreBG/ScoreCalculation
onready var ScoreCalculation_text = $CanvasLayer/ScoreBG/ScoreCalculation/CalcText

onready var FinalScore = $CanvasLayer/ScoreBG/FinalScore
onready var FinalScore_text = $CanvasLayer/ScoreBG/FinalScore/FinalScore

onready var ReplayButton = $CanvasLayer/ScoreBG/SelectUI/ReplayButton
onready var ReturnButton = $CanvasLayer/ScoreBG/SelectUI/ReturnButton

onready var ButtonSound = $ButtonSound
export var sndSelect:AudioStream
export var sndPress:AudioStream

signal replay_game
signal return_to_menu

var score_precalc = []
var finalscore:float
var finalscore_formatted:String
var scorecalculation_format:String = "Base Score %s \n x \n Life Bonus %s \n x \n Multiplier Bonus %s"

func calculate_finalscore(baseScore:float, livesLeft:float, maxMultiplier:float):
	score_precalc = [baseScore, livesLeft, maxMultiplier]
	finalscore = baseScore * (1 + (livesLeft * 0.1) -0.1) * (1 + (maxMultiplier * 0.1) - 0.1)

func set_UI(bOn:bool):
	CanvasLayer.visible = bOn
	$CanvasLayer/ScoreBG/SelectUI/ReplayButton.grab_focus()
	# setting the UI
	ScoreCalculation_text.text = scorecalculation_format % [score_precalc[0], (1 + (score_precalc[1] * 0.1) - 0.1), (1 + (score_precalc[2] * 0.1) - 0.1)]
	FinalScore_text.text = get_formattedFinalScore(finalscore)

# return the score as a formatted string where comma is placed every 3 digits
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