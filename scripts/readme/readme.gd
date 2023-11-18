extends Node

onready var Slideshow = $"ColorRect/Slideshow"
onready var ButtonSound = $ButtonSound

onready var BackButton = $ColorRect/UI/BackButton
onready var NextButton = $ColorRect/UI/NextButton

export var sndSelect:AudioStream
export var sndPress:AudioStream

func _ready():
    Slideshow.show_slide(Slideshow.currentSlide)
    NextButton.grab_focus()

func button_next():
    button_pressed()
    if (Slideshow.currentSlide < Slideshow.slides.size() -1):
        Slideshow.show_slide(Slideshow.currentSlide + 1)
    else:
        return_menu()

func button_back():
    button_pressed()
    if (Slideshow.currentSlide > 0):
        Slideshow.show_slide(Slideshow.currentSlide - 1)
    else:
        return_menu()

func return_menu():
	get_tree().change_scene_to(Global.MainMenuScene)

func button_focus_entered():
    ButtonSound.stream = sndSelect
    ButtonSound.play(0.0)

func button_pressed():
    ButtonSound.stream = sndPress
    ButtonSound.play(0.0)