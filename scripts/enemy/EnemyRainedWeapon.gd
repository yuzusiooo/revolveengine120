extends Node2D
class_name EnemyRangedWeapon

var parent = null

var attackDamage:float = 1
export var speed:float = 300
var velocity:Vector2 = Vector2.ZERO
var despawn:float = 5.0

func set_new(newPos:Vector2, direction:Vector2, newParent, newSpeed):
	self.global_position = newPos
	speed = newSpeed
	rotation = Vector2.UP.angle_to(direction)
	velocity = direction * speed
	parent = newParent

func _physics_process(delta):
	despawn -= delta
	if (despawn <= 0): queue_free()
	# if (!is_instance_valid(parent)): queue_free()
	process_movement(delta)

func process_movement(delta):
	if (velocity != Vector2.ZERO):
		self.global_position += velocity * delta

func _on_CannonEnemyBullet_area_entered(area):
	if (area.get_parent() != null and area.name == "Hitbox"):
		if (area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(attackDamage)
