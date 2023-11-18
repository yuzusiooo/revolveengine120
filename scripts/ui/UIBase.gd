extends Control

class_name UIBase

export var ButtonSound:NodePath
export var sndSelect:AudioStream
export var sndPress:AudioStream

export var UIButtons:Array
export var DefaultButton:NodePath
signal button_pressed(buttonName)

func _ready():
	if (UIButtons.size() > 0): get_node(UIButtons[0]).grab_focus()
	set_buttons()
	c_ready()
	if (DefaultButton):
		get_node(DefaultButton).grab_focus()

# virtual func
func c_ready():
	pass

# virtual func
func sig_button_pressed(buttonName:String):
	pass

# virtual func
func sig_button_focus_entered(buttonName:String):
	pass

func set_buttons():
	for i in UIButtons.size():
		var b = get_node(UIButtons[i])
		# connect signals
		b.connect("pressed", self, "sig_button_pressed", [b.name])
		b.connect("focus_entered", self, "sig_button_focus_entered", [b.name])
		# connect adjacent buttons
		if (i - 1 >= 0):
			b.focus_neighbour_top = get_node(UIButtons[i-1]).get_path()
		if (i + 1 < UIButtons.size()):
			b.focus_neighbour_bottom = get_node(UIButtons[i+1]).get_path()

# these dont work on their own, needs to be called from the inherited function
func button_focus_entered():
	var bs = MusicPlayer.UISound
	bs.stream = sndSelect
	bs.play(0.0)

func button_pressed():         
	var bs = MusicPlayer.UISound
	bs.stream = sndPress
	bs.play(0.0)
	yield(get_tree().create_timer(0.2), "timeout")

# copy paste these to make it to work
# func sig_button_pressed(buttonName:String):
# 	button_pressed()
# 	emit_signal("button_pressed", buttonName)
	
# func sig_button_focus_entered(buttonName:String):
# 	button_focus_entered()
	