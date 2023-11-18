extends Pickup

func _on_Area2D_area_entered(area):
	if (area.get_parent() != null and area.name == "WorldCollision"):
		if (area.get_parent().has_method("pickup_item")):
			area.get_parent().pickup_item("medal", value)
			Global.Main.ScoreManager.add_score(scoreGain, self.global_position)
			queue_free()
