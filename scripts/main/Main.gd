extends Node2D

var Player
var Anchor

onready var MainCamera = $MainCamera
onready var HUD = $HUD
# manager vars
onready var ItemDropManager = $Managers/ItemDropManager
onready var ScoreManager = $Managers/ScoreManager
onready var GameoverManager = $Managers/GameoverManager
onready var HitstopManager = $Managers/HitstopManager
onready var ScoreboardManager = $Managers/ScoreboardManager
onready var ScreenEdgeManager = $Managers/ScreenEdgeManager

var gameStarted:bool = false

func _ready():
	Global.Main = self
	Player = $Player
	Anchor = $Anchor
	gameStarted = true
	# call the init variables for nodes that need it
	MainCamera.init(Player, Anchor)
	MusicPlayer.play_music("Main")

func replay_game():
	# save score
	get_tree().reload_current_scene()

func return_Menu():
	MusicPlayer.stop_music()
	get_tree().change_scene_to(Global.MainMenuScene)

func _on_FinalScoreUI_replay_game():
	replay_game()

func _on_FinalScoreUI_return_to_menu():
	#save score
	return_Menu()

