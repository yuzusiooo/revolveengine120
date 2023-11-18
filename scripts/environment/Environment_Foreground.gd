extends Node2D

onready var PlayareaBorder = $PlayareaBorder

func update_foregroundAlpha(newAlpha):
	PlayareaBorder.modulate.a = newAlpha

func _on_Player_update_wallProximity(newProximityRate):
	update_foregroundAlpha(stepify(sqrt(newProximityRate), 0.1))
