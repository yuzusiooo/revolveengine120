extends vfxparticle

signal animation_ended
signal loopanimation_ended
onready var audio = $AudioStreamPlayer2D



func _on_AnimationPlayer_animation_finished(anim_name:String):
	emit_signal("animation_ended")

func dyingVFX_done():
	args[0].Anim.play("fadeout")
	emit_signal("loopanimation_ended")
	# no idea why but i cant call this from animationPlayer without breaking
	audio.play(0.0)

func c_set_new():
	connect("animation_ended", Global.Main.GameoverManager, "set_FinalScore_UI")
	connect("loopanimation_ended", Global.Main.MainCamera, "_on_PlayerGameover_animation_ended")
	Global.Main.MainCamera.set_cameraMode("Gameover")
