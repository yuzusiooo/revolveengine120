extends Node2D

export var explosionTime:float = 0.5
export var damage:float = 2
var explosionStopTimer:float = 0

func set_new(newPos):
    self.global_position = newPos

func _physics_process(delta):
    explosionStopTimer += delta
    if (explosionStopTimer >= explosionTime):
        queue_free()

func _on_MissileExplosion_area_entered(area:Area2D):
    if (area.get_parent() != null and area.name == "Hitbox"):
        Global.Main.ScoreManager.add_multiplierRate()
        if (area.get_parent().has_method("take_damage")):
            area.get_parent().take_damage(damage)
            queue_free()
