extends Node2D

onready var chromaticAbberationBox = $ChromaticAbberationBox

export var chromaticAbberation_Strength:float = 2.0
export var chromaticAbberation_OffsetAmount:float = 30
var bResetChromaticAbberation:bool = false

func _physics_process(delta):
	if (bResetChromaticAbberation):
		chromaticAbberation_OffsetAmount -= 1 * delta
		if (chromaticAbberation_OffsetAmount <= 0):
			bResetChromaticAbberation = false
			chromaticAbberation_OffsetAmount = 0.0

func start_hitstop(timescale:float, duration:float, buseVisuals:bool = false):
	if (buseVisuals):
		start_hitstop_visuals(duration)
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale), "timeout")
	Engine.time_scale = 1.0

func start_hitstop_visuals(duration:float):
	chromaticAbberationBox.material.set_shader_param("offset", chromaticAbberation_OffsetAmount)
	chromaticAbberationBox.material.set_shader_param("CAStrength", chromaticAbberation_Strength)
	yield(get_tree().create_timer(duration),"timeout")
	chromaticAbberationBox.material.set_shader_param("offset", 0)
	chromaticAbberationBox.material.set_shader_param("CAStrength", 1.0)
