extends CannonEnemy

# attacking 
export var shotsPerBurst:int = 10
export var shotOffset:float = 5
export var burstDelay:float = 0.06

var playerPosition = [Vector2.ZERO, Vector2.ZERO]

func process_fireAtPlayer(delta):
	SpriteBarrel.rotation = Vector2.LEFT.angle_to((self.global_position - Global.Main.Player.global_position))
	if (bCanAttack and OS.get_ticks_msec() & 5 == 0):
		bCanAttack = false
		attackRateTimer = attackRate
		# velocity of the player is playerPos[1] - playerPos[0]
		playerPosition[1] = Player.global_position
		var playerVelocity = playerPosition[1] - playerPosition[0]
		var toPlayerVector = ((playerPosition[1] + playerVelocity) - self.global_position).normalized()
		# var toPlayerVector = (playerPosition[1] - self.global_position).normalized()
		# if can attack, fire bullets shotsPerBurst times
		for b in shotsPerBurst:
			var iBullet = tscnBullet.instance()
			get_tree().get_current_scene().add_child(iBullet)
			var toPlayerVectorR = toPlayerVector.rotated(deg2rad(rand_range(-shotOffset, shotOffset)))
			iBullet.set_new(self.global_position, toPlayerVectorR, self, bulletSpeed)
			get_node(AttackSFX).stream = AttackSFX_Stream
			Anim.play("cannon_fire")
			yield(get_tree().create_timer(burstDelay), "timeout")
	if (!bCanAttack):
		attackRateTimer -= delta
		# make it so that it keeps track of the player's position at set intervals (but not too frequent that the 2 vectors match)
		if (OS.get_ticks_msec() & 50 == 0):
			playerPosition[0] = Player.global_position
	if (attackRateTimer <= 0):
		bCanAttack = true
