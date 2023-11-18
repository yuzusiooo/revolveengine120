extends UIBase


func sig_button_pressed(buttonName:String):
	button_pressed()
	emit_signal("button_pressed", buttonName)

func sig_button_focus_entered(buttonName:String):
	button_focus_entered()
