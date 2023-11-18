extends Node2D

var score:float = 0
var multiplier_level: float = 1
var multiplier_rate:float = 0
var multiplier_nextLevelRate:float = 100
var multiplier_gain:float = 3

var max_multiplierLevel:float = 10

var multiplier_drainDelay:float = 1
var multiplier_drainDelayTimer:float = 0
var multiplier_drain:float = 1
var multiplier_drainIncrease:float = 1
var multiplier_drainIncreaseRate:float = 100

var multiplier_highest:float = 0

var ScoreGaintscn = preload("res://nodes/vfx/ScoreGain.tscn")

export var ComboLevelUpSFX:AudioStream
onready var LevelUpSFX = $LevelUpSFX

signal multi_levelup()
signal update_multiLevel(multiLevel, multiRate)
signal update_score(score)

func _process(delta):
	process_multiplier(delta)

func process_multiplier(delta):
	drain_multiplierRate(delta)
	# clamp
	multiplier_rate = clamp(multiplier_rate, 0, multiplier_nextLevelRate)
	# show on HUD
	emit_signal("update_multiLevel", multiplier_level, multiplier_rate)
	if (multiplier_level > multiplier_highest):
		multiplier_highest = multiplier_level

# called from something that increases the multiplier rate, also resets the drain rate and timer
func add_multiplierRate(bPlayerInRange:bool = true):
	multiplier_rate += multiplier_gain * 1 if bPlayerInRange else 0.5
	multiplier_drainIncrease = 1 
	if (multiplier_rate >= multiplier_nextLevelRate):
		add_comboLevel()

func add_comboLevel():
	# increment multiplier if next level is met
	if (multiplier_level < max_multiplierLevel):
		multiplier_level += 1
		var extraRate = multiplier_rate - multiplier_nextLevelRate
		multiplier_rate = (0 + extraRate)
		LevelUpSFX.stream = ComboLevelUpSFX
		LevelUpSFX.play(0.0)
		emit_signal("multi_levelup")

func drain_multiplierRate(delta):
	if (multiplier_drainDelayTimer > 0):
		multiplier_drainDelayTimer -= delta
	if (multiplier_drainDelayTimer <= 0):
		# drain currentRate by drain
		multiplier_rate -= multiplier_drain * delta * multiplier_drainIncrease
		# drain the rate faster overtime
		multiplier_drainIncrease += multiplier_drainIncreaseRate * delta
		# reduce multiplier level if rate is drained
		if (multiplier_rate <= 0 and multiplier_level > 1):
			multiplier_level -= 1
			multiplier_rate = multiplier_nextLevelRate - 1

func add_score(addScore, addScorePos:Vector2):
	# add and display score
	var totalScore = addScore * multiplier_level
	score += totalScore
	emit_signal("update_score", score)
	# make a score add vfx
	var IScoreGain = ScoreGaintscn.instance()
	get_tree().get_current_scene().add_child(IScoreGain)
	IScoreGain.set_new(addScorePos, totalScore)

func get_scoreStats():
	return [score, multiplier_highest]


func _on_Player_update_HP(newHP):
	multiplier_level = 1
