extends Control

onready var PlayButton = $MenuVBox/PlayButton
onready var OptionsButton = $MenuVBox/OptionsButton
onready var QuitButton = $QuitButton
onready var Descriptor = $DescriptorLabel

var descriptor_text = {
	"PlayButton" : "Aim for the highest score in 120 seconds.",
	"ReadMeButton" : "Introduction to Revolve Engine 120.",
	"OptionsButton" : "Settings and How to play the game.",
	"QuitButton" : "Quit the game.",
	"SendFeedbackButton" : "Open the feedback form. (New Page)"
}

onready var ButtonSound = $ButtonSound
export var sndSelect:AudioStream
export var sndPress:AudioStream

var descriptor_textRate:float = 5

# button signals to be recieved by MainMenu node
signal PlayButton_pressed
signal OptionsButton_pressed
signal ReadMe_pressed

func _ready():
	get_viewport().connect("gui_focus_changed", self, "update_focus")
	PlayButton.grab_focus()

func update_focus(newFocus:Control):
	Descriptor.text = descriptor_text.get(newFocus.name)
	Descriptor.percent_visible = 0

func process_descriptor(delta):
	if (Descriptor.percent_visible < 1):
		Descriptor.percent_visible += delta * descriptor_textRate

func _on_PlayButton_pressed():
	button_pressed()
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("PlayButton_pressed")

func _on_OptionsButton_pressed():
	button_pressed()
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("OptionsButton_pressed")

func _on_ReadMeButton_pressed():
	button_pressed()
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("ReadMe_pressed")
	

func _on_QuitButton_pressed():
	button_pressed()
	get_tree().quit()

func _on_SendFeebackButton_pressed():
	button_pressed()
	Global.send_feedback()

func button_focus_entered():
	ButtonSound.stream = sndSelect
	ButtonSound.play(0.0)

func button_pressed():
	ButtonSound.stream = sndPress
	ButtonSound.play(0.0)
