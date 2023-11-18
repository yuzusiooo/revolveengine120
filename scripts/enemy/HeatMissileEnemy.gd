extends Enemy

class_name HeatMissileEnemy

export var fireTrailtscn:PackedScene

var acceleration:float = 1500
var maxSpeed:float = 1200

var attackDamage:float = 1

var timeUntilStartAttack:float = 0.5
var ctimeUntilStartAttack:float = 0.0

var fireTrailSpawnInterval:float = 0.005
var cfireTrailSpawnInterval:float = fireTrailSpawnInterval

var targetVelocity = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

var possibleDirections = [
	Vector2.UP,
	Vector2.UP + Vector2.RIGHT,
	Vector2.RIGHT,
	Vector2.RIGHT + Vector2.DOWN,
	Vector2.DOWN,
	Vector2.DOWN + Vector2.LEFT,
	Vector2.LEFT,
	Vector2.LEFT + Vector2.UP
]

enum EHeatMissileStatus {
	StandBy,
	PreAttack,
	Attack,
}

var currentStatus = EHeatMissileStatus.StandBy

func set_new_class():
	targetVelocity[0] = Player.global_position

func process_movement(delta):
	match(currentStatus):
		EHeatMissileStatus.StandBy:
			process_StandBy(delta)
		EHeatMissileStatus.PreAttack:
			process_PreAttack(delta)
		EHeatMissileStatus.Attack:
			process_Attack(delta)

func process_StandBy(delta):
	ctimeUntilStartAttack += delta
	if (ctimeUntilStartAttack >= timeUntilStartAttack):
		targetVelocity[1] = Player.global_position
		targetVelocity[2] = (targetVelocity[1] - targetVelocity[0])
		currentStatus = EHeatMissileStatus.PreAttack
	velocity = (Player.global_position - self.global_position).normalized()
	self.global_position += (velocity * speed * delta)

func process_PreAttack(delta):
	velocity = ((targetVelocity[1] + (targetVelocity[2] * 2)) - self.global_position).normalized()
	# get the vector with the lowest dot product
	var closestVector = Vector2.ZERO
	for vec in possibleDirections:
		if !closestVector:
			closestVector = vec
		else:
			closestVector = vec if velocity.dot(vec) > velocity.dot(closestVector) else closestVector
	velocity = closestVector.normalized()
	currentStatus = EHeatMissileStatus.Attack

func process_Attack(delta):
	speed += acceleration * delta
	speed = clamp(speed, 0, maxSpeed)
	self.global_position += (velocity * speed * delta)
	if (cfireTrailSpawnInterval <= 0.0):
		# spawn fire trail
		var IFireTrail = fireTrailtscn.instance()
		get_tree().get_current_scene().add_child(IFireTrail)
		IFireTrail.set_new(self, self.global_position)
		cfireTrailSpawnInterval = fireTrailSpawnInterval
	else:
		cfireTrailSpawnInterval -= delta

func _on_Hurtbox_area_entered(area):
	if (area.get_parent() != null and area.name == "Hitbox"):
		if (area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(attackDamage)
