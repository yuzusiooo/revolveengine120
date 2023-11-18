extends Control

onready var FPSCounter = $CanvasLayer2/FPSCounter

onready var CanvasLayer = $CanvasLayer

# UI Left side
# Time Left
onready var TimeLeft_Label = $CanvasLayer/UILeft/TimeLeft/Label
# HP
onready var HP_Label = $CanvasLayer/UILeft/HP/Label
#Weapon
onready var Weapon_Label = $CanvasLayer/UILeft/Weapon/Label
onready var Weapon_ProgressBar = $CanvasLayer/UILeft/Weapon/TextureProgress

# UI Right side
# Score
onready var Score_Label = $CanvasLayer/UIRight/Score/LabelAnchor/Label
onready var Score_LabelAnchor = $CanvasLayer/UIRight/Score/LabelAnchor
var bScoreUpdate:bool = false
# Multi
onready var Multi_Label = $CanvasLayer/UIRight/Multi/Label
onready var Multi_ProgressBar = $CanvasLayer/UIRight/Multi/TextureProgress


func _physics_process(delta):
	FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second()) + " " + Global.Game_Version
	process_scoreLabel(delta)

func process_scoreLabel(delta:float):
	if (bScoreUpdate):
		Score_LabelAnchor.rect_scale = Vector2.ONE * 1.2
		bScoreUpdate = false
	if (Score_LabelAnchor.rect_scale > Vector2.ONE):
		Score_LabelAnchor.rect_scale -= Vector2.ONE * 5 * delta

func set_UI(bOn:bool):
	CanvasLayer.visible = bOn

# Time Left
func set_TimeLeft(newTime:String):
	TimeLeft_Label.text = newTime

# HP
func set_HP(newHP:int):
	HP_Label.text = str(newHP)

# Weapon
func set_WeaponLevel(newLevel:int):
	Weapon_Label.text = "LVL"+str(newLevel)

func set_WeaponXPRate(newXP:float, nextLevelUpXP:float):
	Weapon_ProgressBar.value = (newXP / nextLevelUpXP) * 100

#Score
func set_Score(newScore:float):
	Score_Label.text = str(newScore)
	bScoreUpdate = true

# Multi
func set_Multi(newMultiLevel:float, newMultiRate:float):
	Multi_Label.text = str(newMultiLevel)+"x"
	Multi_ProgressBar.value = newMultiRate
