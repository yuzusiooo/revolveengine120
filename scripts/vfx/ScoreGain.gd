extends Node2D

onready var GainLabel = $Label

var despawn:float = 1
var flashModulate:float = 0

func _physics_process(delta):
	despawn -= delta
	if (despawn < 0): queue_free()
	if (despawn < 0.5):
		self.scale -= Vector2(1, 1) * delta
	self.global_position += Vector2.UP * 10 * delta

func set_new(newPos, newScore):
	self.global_position = newPos
	GainLabel.text = String(newScore)
	GainLabel.self_modulate.h = randf()
