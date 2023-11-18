extends Enemy

class_name RamEnemy

var acceleration:float = 300
var maxSpeed:float = 300

var attackDamage:float = 1

var chaseTime:float = 0.5

onready var SpriteAnim = $SpriteAnchor/AnimationPlayer

func set_new_class():
	velocity = (Player.global_position - self.global_position).normalized()
	speed = 0

func process_movement(delta):
	# make the enemy chase the player for brief period of time
	if (chaseTime > 0):
		chaseTime -= delta
		velocity = (Player.global_position - self.global_position).normalized()
	# accelerate the player and set its position
	speed += acceleration * delta
	speed = clamp(speed, 0, maxSpeed)
	self.global_position += (velocity * speed * delta)
	process_visual(delta)

func _on_Hurtbox_area_entered(area):
	if (area.get_parent() != null and area.name == "Hitbox"):
		if (area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(attackDamage)

func process_visual(delta):
	if !(chaseTime > 0) and SpriteAnim.current_animation != "attack":
		SpriteAnim.play("attack")
	self.rotation = Vector2.RIGHT.angle_to(velocity)
