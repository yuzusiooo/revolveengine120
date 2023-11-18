extends Node

# variable containing the Main player
var Main

# preloaded scenes
var MainMenuScene = preload("res://scenes/MainMenu.tscn")
var MachineSelectScene = preload("res://scenes/MachineSelectMenu.tscn")
var MainGameScene = preload("res://scenes/Main3.tscn")
var ReadMeScene = preload("res://scenes/ReadMe.tscn")
var OptionsScene = preload("res://scenes/OptionsMenu2.tscn")

# tscns for some nodes to load
var SFXOneShot = preload("res://nodes/vfx/SFXOneShot.tscn")

# game project info
var Game_Version = "Alpha 1"
var Feedback_URL = "https://forms.gle/hjsrYGok6VPJLYro7"

# player machine stats
var CurrentPlayerMachine:playerMachineRes

# options var
var bFullscreen:bool = false
enum eControlMode {
	eightway,
	rotate
}
var cControlMode = eControlMode.eightway

func send_feedback():
	print("open feedback")
	OS.shell_open(Feedback_URL)
