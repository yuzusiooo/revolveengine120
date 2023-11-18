extends Control

onready var FPSCounter = $CanvasLayer/FPSCounter

onready var PlayerHP_Label = $CanvasLayer/PlayerHP/Label
onready var PlayerHP_Sprite = $CanvasLayer/PlayerHP/Sprite
onready var PlayerHP_AnimPlayer = $CanvasLayer/PlayerHP/AnimationPlayer
onready var PlayerHP_ParticleSpawnPoint = $CanvasLayer/PlayerHP/ParticleSpawnPoint
var tscnLoseHealthVFX = preload("res://nodes/vfx/particles/PlayerLoseHealth.tscn")

onready var WeaponLevel_Label = $CanvasLayer/WeaponLevel/Label
onready var WeaponLevel_Sprite = $CanvasLayer/WeaponLevel/Sprite

var WeaponIcon = [preload("res://assets/sprites/spr_ui_ammoIcon_gray.png"), preload("res://assets/sprites/spr_ui_ammoIcon.png")]

onready var TimeLeft_Label = $CanvasLayer/TimeLeft/Label

onready var Score_Label = $CanvasLayer/Score/LabelAnchor/Label
onready var Score_LabelAnchor = $CanvasLayer/Score/LabelAnchor
onready var Score_MultiplierLabel = $CanvasLayer/Score/MutiAnchor/MultiplierLabel
onready var Score_MultiAnchor = $CanvasLayer/Score/MutiAnchor
onready var Score_MultiplierRate = $CanvasLayer/Score/TextureProgress
var MultiplierLabelFont = preload("res://assets/fonts/UI/DynFont_MultiplierLabel.tres")
var bScoreUpdate:bool = false

func _physics_process(delta):
	FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second()) + " " + Global.Game_Version
	process_scoreLabel(delta)

func process_scoreLabel(delta:float):
	if (bScoreUpdate):
		Score_LabelAnchor.rect_scale = Vector2.ONE * 1.5
		bScoreUpdate = false
	if (Score_LabelAnchor.rect_scale > Vector2.ONE):
		Score_LabelAnchor.rect_scale -= Vector2.ONE * 5 * delta

func set_PlayerHP(newHP:int):
	PlayerHP_Label.text = str(newHP)
	PlayerHP_Sprite.material.set_shader_param("flash", lerp(0.0, 1.0, float(newHP/5.0)))
	PlayerHP_AnimPlayer.playback_speed = lerp(3.0, 1.0, float(newHP/5.0))

func set_WeaponLevel(newXP:float):
	WeaponLevel_Label.text = str(newXP)

func set_WeaponLevelSprite(newLevel:int):
	if (newLevel == 2):
		WeaponLevel_Sprite.material.set_shader_param("glow_on", true)
		return
	if (newLevel == 1):
		WeaponLevel_Sprite.texture = WeaponIcon[1]

func set_TimeLeft(newTime:String):
	TimeLeft_Label.text = newTime

func set_ScoreLabel(newScore:float):
	Score_Label.text = str(newScore)
	bScoreUpdate = true

func set_ScoreMultiplier(newMult:float, newMultiRate:float):
	Score_MultiplierLabel.text = str(newMult) + "x"
	Score_MultiplierLabel.modulate.a = lerp(0.3, 1.5, newMultiRate/100)
	Score_MultiAnchor.rect_scale = Vector2.ONE * lerp(1, 2 + (newMult * 0.1), newMultiRate/100)
	Score_MultiplierRate.value = newMultiRate


