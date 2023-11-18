extends Enemy
class_name CannonEnemy

# furthest point it can go from the center when it first moves
var maxPointDistance:float = 256
var minPointDistance:float = 184

# random point that it will move to before firing at the player
var originPoint:Vector2 = Vector2.ZERO
var firePoint:Vector2 = Vector2.ZERO
var bAtfirePoint:bool = false

# attacking
var tscnBullet = preload("res://nodes/enemy/CannonEnemyBullet.tscn")
var attackRate:float = 2.0
var attackRateTimer:float = 0.0
var bCanAttack:bool = true
export var bulletSpeed:float = 300
# visual
onready var SpriteLegs = $SpriteAnchor/Legs
onready var SpriteBarrel = $SpriteAnchor/Barrel
onready var Anim = $SpriteAnchor/AnimationPlayer

# Statemachine
enum State {
	state_moveToPosition,
	state_attack
}
var cState = State.state_moveToPosition

func set_new_class():
	originPoint = self.global_position
	# set a random point on the arena to move to
	firePoint = self.global_position + (Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)) * lerp(minPointDistance, maxPointDistance, randf()))

func process_movement(delta):
	match (cState):
		State.state_moveToPosition:
			process_moveToPosition(delta)
		State.state_attack:
			if (bAtfirePoint):
				process_fireAtPlayer(delta)

func process_moveToPosition(delta):
	if (!bAtfirePoint):
		velocity = (firePoint - self.global_position).normalized()
		var moveProgRate:float = 0.001 + self.global_position.distance_to(firePoint) / originPoint.distance_to(firePoint)
		self.global_position += velocity * (speed * lerp(0, 1, moveProgRate)) * delta
		SpriteLegs.rotation_degrees += 360.0 * delta;
	if (self.global_position.distance_to(firePoint) <= randf() * 50.0):
		bAtfirePoint = true
		cState = State.state_attack

func process_fireAtPlayer(delta):
	# SpriteBarrel.rotation = self.global_position.angle_to_point(Global.Main.Player.global_position)
	# self.rotation = Vector2.RIGHT.angle_to(velocity)
	# SpriteBarrel.rotation = (self.global_position * Vector2.RIGHT).angle_to_point(Global.Main.Player.global_position)
	SpriteBarrel.rotation = Vector2.LEFT.angle_to((self.global_position - Global.Main.Player.global_position))
	if (bCanAttack and OS.get_ticks_msec() % 5 == 0):
		var iBullet = tscnBullet.instance()
		get_tree().get_current_scene().add_child(iBullet)
		var toPlayerVector = (Global.Main.Player.global_position - self.global_position).normalized()
		iBullet.set_new(self.global_position, toPlayerVector, self, bulletSpeed)
		attackRateTimer = attackRate
		bCanAttack = false
		if (Anim.current_animation != "cannon_fire"):
			get_node(AttackSFX).stream = AttackSFX_Stream
			Anim.play("cannon_fire")
	if (!bCanAttack):
		attackRateTimer -= delta
	if (attackRateTimer <= 0):
		bCanAttack = true


# func process_movement(delta):
# 	process_movetoFirePosition(delta)
# 	if (bAtfirePoint):
# 		process_fireatPlayer(delta)

# func process_movetoFirePosition(delta):
# 	if (!bAtfirePoint):
# 		velocity = (firePoint - self.global_position).normalized()
# 		var moveProgRate:float = self.global_position.distance_to(firePoint) / originPoint.distance_to(firePoint)
# 		self.global_position += velocity * (speed * lerp(0, 1, moveProgRate)) * delta
# 	if (self.global_position.distance_to(firePoint) <= randf() * 100.0):
# 		bAtfirePoint = true

# func process_fireatPlayer(delta):
# 	self.rotation = self.global_position.angle_to_point(Global.Main.Player.global_position)
# 	if (bCanAttack and OS.get_ticks_msec() % 5 == 0):
# 		var iBullet = tscnBullet.instance()
# 		get_tree().get_current_scene().add_child(iBullet)
# 		var toPlayerVector = (Global.Main.Player.global_position - self.global_position).normalized()
# 		iBullet.set_new(self.global_position, toPlayerVector, self)
# 		attackRateTimer = attackRate
# 		bCanAttack = false
# 	if (!bCanAttack):
# 		attackRateTimer -= delta
# 	if (attackRateTimer <= 0):
# 		bCanAttack = true
