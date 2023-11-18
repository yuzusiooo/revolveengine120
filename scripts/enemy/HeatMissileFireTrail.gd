extends Node2D

class_name HeatMissileFireTrail

export var attackDamage:float = 1.0

var spawnOffset:float = 7.0

export var despawnTimer:float = 2.0
var cdespawnTimer:float = 0.0

func set_new(parent, newPos):
    newPos.x += rand_range(-randf(), randf()) * spawnOffset
    newPos.y += rand_range(-randf(), randf()) * spawnOffset
    self.global_position = newPos
    cdespawnTimer = despawnTimer

func _process(delta):
    cdespawnTimer -= delta
    if (cdespawnTimer <= 0.0):
        queue_free()

func _on_Hurtbox_area_entered(area):
    if (area.get_parent() != null and area.name == "Hitbox"):
        if (area.get_parent().has_method("take_damage")):
            area.get_parent().take_damage(attackDamage)
