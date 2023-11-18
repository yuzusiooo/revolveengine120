extends PlayerMainWeapon
class_name PlayerBullet

var velocity:Vector2 = Vector2.ZERO
var damage:float = 1
var speed:float = 2000
var despawn:float = 5.0

func _physics_process(delta):
	# timer until despawn
	despawn -= delta
	if (despawn <= 0):
		queue_free()
	process_movement(delta)

func process_movement(delta):
	if (velocity != Vector2.ZERO):
		self.global_position += velocity * delta

# set the direction the bullet should go to, and the position it should spawn at
func set_new(direction:Vector2, newPosition:Vector2):
	self.global_position = newPosition
	rotation = Vector2.UP.angle_to(direction)
	velocity = direction * speed

# call the take_damage() func to the enemy and destroy self
func _on_PlayerBullet_area_entered(area):
	if (area.get_parent() != null and area.name == "Hitbox"):
		Global.Main.ScoreManager.add_multiplierRate(player_inEffectiveDistance(area))
		if (area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(damage)
			queue_free()
