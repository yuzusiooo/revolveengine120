extends Node

onready var MainMusic = $Main
onready var MuffledMusic = $Muffled
onready var UISound = $UISound

export var muffleResetTime:float = 5.0
export var baseVolume:float = -10
export var muffleVolume:float = -50

var cMuffleResetTime = -1
export var musicTracks = {}
var currentMusic = ""


func _ready():
    MainMusic.volume_db = baseVolume
    MuffledMusic.volume_db = muffleVolume

func _process(delta):
	if (cMuffleResetTime != -1):
		cMuffleResetTime -= delta
		MuffledMusic.volume_db = lerp(baseVolume, muffleVolume, (cMuffleResetTime / muffleResetTime))
		MainMusic.volume_db = lerp(baseVolume, muffleVolume, (cMuffleResetTime / muffleResetTime))
		if (cMuffleResetTime <= 0):
			cMuffleResetTime = -1

func play_music(trackName:String):
    match(trackName):
        "Main":
            MainMusic.stream = musicTracks["Main"]
            MuffledMusic.stream = musicTracks["Muffled"]
            currentMusic = "Main"
        "Menu":
            MainMusic.stream = musicTracks["Menu"]
            MuffledMusic.stream = null
            currentMusic = "Menu"
    MainMusic.play(0.0)
    MuffledMusic.play(0.0)

func start_muffled():
	MuffledMusic.volume_db = baseVolume
	MainMusic.volume_db = muffleVolume

func stop_music():
    MainMusic.stop()
    MuffledMusic.stop()

func reset_muffled():
    cMuffleResetTime = muffleResetTime
