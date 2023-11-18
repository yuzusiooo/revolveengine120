extends KinematicBody2D

var hp:float = 5

var currentMachine

# movement vars
var moveSpeed:float = 400
var velocity:Vector2 = Vector2.ZERO
var bmoveSlow:bool = false
var bmoveSlowOverride:bool = false

# anchor circling movement 
export(NodePath) var Anchor
var anchorPoint:Vector2 = Vector2.ZERO
var offsetLength:float = 350

# weapon vars
onready var Weapon = $Weapon

# iframe vars
var biframeOn:bool = false
var iframe_duration:float = 3.0
var iframe_time:float = 0

# visual vars
onready var SpriteAnchor = $SpriteAnchor
onready var PlayerSprite = $SpriteAnchor/Sprite
onready var SpriteAnim = $SpriteAnchor/AnimationPlayer
var lastDirection:int = 0
var tscntakeDamageVFX = preload("res://nodes/vfx/particles/player/PlayerTakeDamage.tscn")
var playerShadowtscn = preload("res://nodes/player/PlayerShadow.tscn")

# sounds
onready var PickupSFX = $ItemPickupRange/PickupSFX
export var WeaponGemPickupSFX:AudioStream
export var MedalPickupSFX:AudioStream

onready var HitSFX = $Hitbox/PlayerHitSFX
export var PlayerTakeDamageSFX:AudioStream

# signal
signal take_damage(newhp)
signal level_up(newLevel)
signal update_weaponXP(newXP)
signal update_wallProximity(newProximityRate)
signal need_weapon(machineVariable)

func _ready():
	# set the anchorPoint if its set
	if (Anchor != ""): anchorPoint = get_node(Anchor).global_position
	currentMachine = Global.CurrentPlayerMachine

func _physics_process(delta):
	if (Global.Main.gameStarted):
		process_movement(delta)
		process_wallProximity(delta)
		process_weapon(delta)
		process_visual(delta)
		process_iframe(delta)
	if (!Global.Main.gameStarted):
		set_iframe(true)

# return the arrow key input as vector2
func get_inputVector():
	return Vector2(
		Input.get_action_strength("key_right") - Input.get_action_strength("key_left"),
		Input.get_action_strength("key_down") - Input.get_action_strength("key_up"))

func process_movement(delta):
	# make the player move slower if shift is being pressed
	# do this only when it hasnt used the sub weapon
	if (!bmoveSlowOverride):
		bmoveSlow = Input.get_action_strength("key_shift")
	var inputVector = get_inputVector()
	velocity = inputVector * get_moveSpeed()
	velocity = move_and_slide(velocity)
	# restrict the player's position in a circular area relative to the anchorPoint
	self.global_position = clamp_vector(self.global_position, anchorPoint, offsetLength)

func get_moveSpeed():
	return moveSpeed * (0.5 if bmoveSlow else 1)

func clamp_vector(vector, clampOrigin, clampLength):
	var offset = vector - clampOrigin
	return clampOrigin + offset.limit_length(clampLength)

func process_wallProximity(delta):
	# get the rate between the offsetLength and the current distance
	var distanceRate = (anchorPoint.distance_to(self.global_position) / offsetLength)
	emit_signal("update_wallProximity", distanceRate)

func process_weapon(delta):
	# rotate the weapon so that it points to the anchor first
	Weapon.rotation = anchorPoint.angle_to_point(Weapon.global_position)
	# separate process function needs to be called to properly process the weapon fire rate
	Weapon.process_weapon(delta)
	if (Input.is_action_pressed("key_a")):
		Weapon.fire_mainWeapon(delta)
	if (Input.is_action_pressed("key_b")):
		Weapon.fire_subWeapon(delta)

func take_damage(damage):
	if (!biframeOn):
		take_damage_fx()
		set_iframe(true)
		hp -= damage
		# reset weapon XP to 1
		
		emit_signal("take_damage", hp)
		if (hp <= 0): player_dead()

func take_damage_fx():
	if (!HitSFX.playing):
		HitSFX.stream = PlayerTakeDamageSFX
		HitSFX.play()
	var ItakeDamageVFX = tscntakeDamageVFX.instance()
	get_tree().get_current_scene().add_child(ItakeDamageVFX)
	ItakeDamageVFX.set_new(self.global_position, [self])
	Global.Main.HitstopManager.start_hitstop(0.1, 0.5)
	Global.Main.MainCamera.start_camera_shake(200, 0.5)

func player_dead():
	hp = 0
	Global.Main.GameoverManager.gameover()

func process_visual(delta):
	# get the inputvector and check if its different to the last direction
	var inputVector = get_inputVector()
	# update the direction if its different and play the new animation
	if (int(inputVector.x) != lastDirection):
		lastDirection = int(inputVector.x)
		match(lastDirection):
			0: SpriteAnim.play("RESET")
			1: SpriteAnim.play("leanRight")
			-1: SpriteAnim.play("leanLeft")
	if (biframeOn):
		SpriteAnim.play("hit")
	# rotate the sprite anchor
	SpriteAnchor.rotation = Weapon.rotation
	# Spawn a shadow if player is moving
	if (velocity != Vector2.ZERO):
		var playerShadowI = playerShadowtscn.instance()
		get_tree().get_current_scene().add_child(playerShadowI)
		playerShadowI.set_new(self.global_position, SpriteAnchor.rotation, PlayerSprite.texture, [PlayerSprite.hframes, PlayerSprite.vframes], PlayerSprite.frame)

func pickup_item(itemName:String, itemValue:float):
	match(itemName.to_lower()):
		"weapongem":
			Weapon.pickup_weaponGem(itemValue)
			SFX_play("PickupSFX", WeaponGemPickupSFX)
		"medal":
			# score gain is handled by the medal
			SFX_play("PickupSFX", MedalPickupSFX)

func process_iframe(delta):
	if (biframeOn):
		iframe_time -= delta
		if (iframe_time <= 0.0):
			set_iframe(false)
		if (SpriteAnim.current_animation != "hit"):
			SpriteAnim.play("hit")

func set_iframe(on:bool):
	match(on):
		true:
			biframeOn = true
			iframe_time = iframe_duration
			$Hitbox.set_deferred("monitorable", false)
		false:
			biframeOn = false
			iframe_time = 0
			$Hitbox.set_deferred("monitorable", true)
			SpriteAnim.play("RESET")

func _on_ItemPickupRange_area_entered(area):
	if (area.get_parent().has_method("start_followPlayer")):
		area.get_parent().start_followPlayer(self)

func SFX_play(targetSFX:String, SFXToPlay:AudioStream):
	match(targetSFX.to_lower()):
		"pickupsfx":
			PickupSFX.stream = SFXToPlay
			PickupSFX.play(0.0)

func get_hp():
	return hp

func _on_Weapon_need_weapon(machineVariable):
	machineVariable.machineWeapon = currentMachine

func _on_Weapon_toggle_useSubweapon(busing):
	bmoveSlow = busing
	bmoveSlowOverride = busing

func _on_Weapon_update_weaponLevel(xpAmount):
	emit_signal("update_weaponXP", xpAmount)

func _on_Weapon_weapon_levelup(newLevel):
	emit_signal("level_up", newLevel)
