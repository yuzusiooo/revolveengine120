extends PlayerSubWeapon
class_name PlayerLockonMissile

var velocity:Vector2 = Vector2.ZERO
var speed:float = -350
var maxSpeed:float = 1000
var acceleration:float = 1000

var damage:float = 5
var lockonEnemy = null

var despawn:float = 3.0

var missileExplosiontscn = preload("res://nodes/player/PlayerMissileExplosion.tscn")

func _physics_process(delta):
	despawn -= delta
	if (despawn <= 0): queue_free()
	process_lockon(delta)
	process_movement(delta)

func process_lockon(delta):
	if (lockonEnemy != null and is_instance_valid(lockonEnemy)):
		velocity = (lockonEnemy.global_position - self.global_position).normalized()
	if (lockonEnemy == null):
		# find the closest enemy thats not already locked on
		var allEnemy = get_tree().get_nodes_in_group("Enemy")
		var enemyDist:float = 0
		var currentClosest = null
		for enemy in allEnemy:
			if (enemyDist == 0):
				enemyDist = self.global_position.distance_to(enemy.global_position)
				currentClosest = enemy
			else:
				if (self.global_position.distance_to(enemy.global_position) < enemyDist):
					enemyDist = self.global_position.distance_to(enemy.global_position)
					currentClosest = enemy
		if (is_instance_valid(currentClosest)):
			if (!currentClosest.bLockedOn):
				currentClosest.bLockedOn = true
				lockonEnemy = currentClosest

func process_movement(delta):
	if (velocity != Vector2.ZERO):
		if (speed <= maxSpeed):
			speed += acceleration * delta
		self.global_position += velocity * speed * delta
		rotation = Vector2.UP.angle_to(velocity)

func set_new(direction:Vector2, newPos:Vector2):
	self.global_position = newPos
	rotation = Vector2.UP.angle_to(direction)
	velocity = direction

func _on_PlayerLockonMissile_area_entered(area):
	if (area.get_parent() != null and area.name == "Hitbox"):
		Global.Main.ScoreManager.add_multiplierRate()
		if (area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(damage)
			# create the explosion before removing self
			var explosionI = missileExplosiontscn.instance()
			get_tree().get_current_scene().call_deferred("add_child", explosionI)
			explosionI.set_new(self.global_position)
			yield()
			queue_free()
