extends Sprite

export var fadeoutTime:float = 0.1
var cfadeoutTime:float = 0

func set_new(newpos:Vector2, newrotation:float, newtex:StreamTexture, animframes:Array, animcurrentframe: int):
	texture = newtex
	hframes = animframes[0]
	vframes = animframes[1]
	frame = animcurrentframe
	self.global_position = newpos
	self.rotation_degrees = rad2deg(newrotation) + 90
	
	cfadeoutTime = fadeoutTime

func _physics_process(delta):
	cfadeoutTime -= delta
	if (cfadeoutTime <= 0.0):
		queue_free()
	scale.x = (1 + cfadeoutTime)
	material.set_shader_param("transparency", lerp(1, 0, cfadeoutTime/fadeoutTime))
