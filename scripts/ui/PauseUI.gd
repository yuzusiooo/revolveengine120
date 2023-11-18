extends Control

onready var CanvasLayer = $CanvasLayer

# sound
onready var ButtonSound = $ButtonSound
export var sndSelect:AudioStream
export var sndPress:AudioStream

signal resume_pressed
signal quit_pressed
signal restart_pressed

func set_UI(bOn:bool):
	CanvasLayer.visible = bOn
	$CanvasLayer/ColorRect2/Control/ResumeButton.grab_focus()

func button_focus_entered():
	ButtonSound.stream = sndSelect
	ButtonSound.play(0.0)

func button_pressed():
	ButtonSound.stream = sndPress
	ButtonSound.play(0.0)


func _on_QuitButton_pressed():
	button_pressed()
	emit_signal("quit_pressed")

func _on_ResumeButton_pressed():
	button_pressed()
	emit_signal("resume_pressed")

func _on_RestartButton_pressed():
	button_pressed()
	emit_signal("restart_pressed")
