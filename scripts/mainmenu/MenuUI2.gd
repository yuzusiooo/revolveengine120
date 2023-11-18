extends UIBase

export var Descriptor:NodePath

var descriptor_text = {
	"PlayButton" : "Aim for the highest score in 120 seconds.",
	"ReadMeButton" : "Introduction to Revolve Engine 120.",
	"OptionsButton" : "Change the game settings.",
	"QuitButton" : "Quit the game.",
	"SendFeedbackButton" : "Open the feedback form. (New Page)"
}
var descriptor_textRate:float = 5

func c_ready():
	# this one is calling update_focus when the button selection changes so that the descriptor can be used
	get_viewport().connect("gui_focus_changed", self, "update_focus")
	get_node(UIButtons[0]).grab_focus()
	update_focus(get_node(UIButtons[0]))

	
func update_focus(newFocus:Control):
	get_node(Descriptor).text = descriptor_text.get(newFocus.name)
	get_node(Descriptor).percent_visible = 0

func process_descriptor(delta):
	if (get_node(Descriptor).percent_visible < 1):
		get_node(Descriptor).percent_visible += delta * descriptor_textRate

func sig_button_pressed(buttonName:String):
	button_pressed()
	emit_signal("button_pressed", buttonName)

func sig_button_focus_entered(buttonName:String):
	button_focus_entered()
