extends Node2D

onready var ASPlayer = $AudioStreamPlayer

func set_new(newPos:Vector2, newStream:AudioStream):
	self.global_position = newPos
	ASPlayer.stream = newStream
	ASPlayer.play()

func _on_AudioStreamPlayer_finished():
	queue_free()
