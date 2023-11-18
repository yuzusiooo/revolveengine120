extends KinematicBody2D

class_name Player2

# player stats
export var startingHP:float = 5
var HP:float

# movement vars
export var moveSpeed:float = 400
var velocity:Vector2 = Vector2.ZERO
var bmoveSlow:bool = false
var bmoveSlowOverride:bool = false
var bdisableInputByDamage:bool = false

# anchor circling movement 
export(NodePath) var Anchor
var anchorPoint:Vector2 = Vector2.ZERO
var offsetLength:float = 350

# visual and iframe vars
var biframeOn:bool = false
var iframe_duration:float = 3.0
var iframe_time:float = 0
var tscntakeDamageVFX = preload("res://nodes/vfx/particles/player/PlayerTakeDamage.tscn")
var lastDirection:int = 0
var tscnGameoverVFX = preload("res://nodes/vfx/particles/player/PlayerGameover.tscn")

# sounds
export var WeaponGemPickupSFX:AudioStream
export var MedalPickupSFX:AudioStream
export var PlayerTakeDamageSFX:AudioStream

# Hitboxes
onready var Hitbox = $Hitbox
onready var PlayerHitSFX = $Hitbox/PlayerHitSFX
onready var ItemPickupRange = $ItemPickupRange
onready var ItemPickupSFX = $ItemPickupRange/ItemPickupSFX

# PlayerMachine
onready var PlayerMachineNode = $PlayerMachine

# Wall proximity
export var wallProximity_WarningRate:float = 0.95
export var wallProximity_Timeout:float = 5.0
var wallProximity_cTimeout:float = wallProximity_Timeout


# Signals
signal update_HP(newHP)
signal player_dead()
signal weapon_levelup(newLevel)
signal weapon_xpGain(newXP, xpToLevelUp)

func _ready():
	HP = startingHP
	if (Anchor != ""): anchorPoint = get_node(Anchor).global_position
	# get the current machine from Global and add it as a child of this node
	# update the PlayerMachineNode to the PlayerMachine class node inside it
	PlayerMachineNode = PlayerMachineNode.get_child(0)

func _physics_process(delta):
	if (Global.Main.gameStarted):
		process_movement(delta)
		process_iframe(delta)
		process_playermachine(delta)
		process_visuals(delta)
		process_wallProximity(delta)
	if (!Global.Main.gameStarted):
		set_iframe(true)

# MOVEMENT FUNCTIONS
func process_movement(delta):
	match (Global.cControlMode):
		Global.eControlMode.eightway:
			# do the normal controls
			if (!bmoveSlowOverride and !bdisableInputByDamage):
				bmoveSlow = Input.get_action_strength("key_shift")
			var inputVector = get_inputVector()
			velocity = inputVector * get_moveSpeed()
			velocity = move_and_slide(velocity)
			# restrict player's movement around the anchorpoint
			self.global_position = clamp_vector(self.global_position, anchorPoint, offsetLength)
		Global.eControlMode.rotate:
			position = anchorPoint
			pass


func get_inputVector():
	return Vector2(
		Input.get_action_strength("key_right") - Input.get_action_strength("key_left"),
		Input.get_action_strength("key_down") - Input.get_action_strength("key_up")
	).normalized()

func get_moveSpeed():
	return moveSpeed * (0.5 if bmoveSlow else 1)

func clamp_vector(vector, clampOrigin, clampLength):
	# return the vector clamped by clampLength
	var offset = vector - clampOrigin
	return clampOrigin + offset.limit_length(clampLength)

func process_wallProximity(delta):
	var proxRate = get_wallproximityRate()
	if (proxRate >= wallProximity_WarningRate):
		wallProximity_cTimeout -= delta
		print(wallProximity_cTimeout)
		# call the manager to show the warning border animation
		Global.Main.ScreenEdgeManager.border_blink(2.0 if wallProximity_cTimeout < 1.0 else 1.0)
		# update this so there's a visual indication that the player is going to die if they stay for too long
		if (wallProximity_cTimeout <= 0):
			player_dead()
	else:
		wallProximity_cTimeout += delta
		wallProximity_cTimeout = clamp(wallProximity_cTimeout, 0, wallProximity_Timeout)
		Global.Main.ScreenEdgeManager.border_reset()

func get_wallproximityRate():
	# get the rate between the offsetLength and the current distance
	return (anchorPoint.distance_to(self.global_position) / offsetLength)
	

# DAMAGE
func take_damage(damage):
	if (!biframeOn):
		set_iframe(true)
		# play the effects for taking damage
		play_takeDamageVFX()
		# reduce weapon xp to 0
		PlayerMachineNode.Weapon.reset_XP()
		# take health damage
		HP -= damage
		if (HP <= 0): player_dead()
		emit_signal("update_HP", HP)

func play_takeDamageVFX():
	if (!PlayerHitSFX.playing):
		PlayerHitSFX.stream = PlayerTakeDamageSFX
		PlayerHitSFX.play()
	var ItakeDamageVFX = tscntakeDamageVFX.instance()
	get_tree().get_current_scene().add_child(ItakeDamageVFX)
	ItakeDamageVFX.set_new(self.global_position, [self])
	Global.Main.HitstopManager.start_hitstop(0.1, 0.15, true)
	Global.Main.MainCamera.start_camera_shake(200, 0.5)
	disable_inputByDamage(iframe_duration/2)

func disable_inputByDamage(duration:float):
	bdisableInputByDamage = true
	bmoveSlow = bdisableInputByDamage
	yield(get_tree().create_timer(duration), "timeout")
	bdisableInputByDamage = false
	bmoveSlow = bdisableInputByDamage


func player_dead():
	HP = 0
	PlayerMachineNode.player_dead()
	var IGameoverVFX = tscnGameoverVFX.instance()
	get_tree().get_current_scene().add_child(IGameoverVFX)
	IGameoverVFX.set_new(self.global_position, [self.PlayerMachineNode])
	emit_signal("player_dead")

func get_hp():
	return HP

# IFRAME FUNCTIONS
func process_iframe(delta):
	if (biframeOn):
		MusicPlayer.start_muffled()
		iframe_time -= delta
		if (iframe_time <= 0.0):
			set_iframe(false)
			MusicPlayer.reset_muffled()
			# play PlayerMachine's Hit animation

func set_iframe(bon):
	match(bon):
		true:
			biframeOn = true
			iframe_time = iframe_duration
			Hitbox.set_deferred("monitorable", false)
		false:
			biframeOn = false
			iframe_time = 0
			Hitbox.set_deferred("monitorable", true)
			# play PlayerMachine's RESET animation

# ITEMS
func pickup_item(itemName:String, itemValue:float):
	match(itemName.to_lower()):
		"weapongem":
			PlayerMachineNode.pickup_weaponGem(itemValue)
			SFX_play("pickupsfx", WeaponGemPickupSFX)
		"medal":
			# pickup effect is handled by medal node
			SFX_play("pickupsfx", MedalPickupSFX)

func SFX_play(targetSFX:String, SFXToPlay:AudioStream):
	match(targetSFX.to_lower()):
		"pickupsfx":
			ItemPickupSFX.stream = SFXToPlay
			ItemPickupSFX.play(0.0)

# PLAYERMACHINE INTERACTION
func process_playermachine(delta):
	# run each of the PlayerMachine's process_ function from here
	if (!bdisableInputByDamage):
		PlayerMachineNode.process_PlayerMachine(delta)
	PlayerMachineNode.process_Rotation(anchorPoint.angle_to_point(self.global_position))

func process_visuals(delta):
	var animName:String = ""
	# get the inputvector and check if its different to the last direction
	var iv = get_inputVector()
#	var inputVector = get_inputVector()
#	# update the direction if its different and play the new animation
	if (int(iv.x) != lastDirection):
		lastDirection = int(iv.x)
		match(lastDirection):
			0: animName = "RESET"
			1: animName = "LeanRight"
			-1: animName = "LeanLeft"
	if (biframeOn):
		animName = "Hit"
	PlayerMachineNode.play_animation(animName)
	PlayerMachineNode.process_shadow(velocity)

# SIGNAL FUNCTIONS
func _on_ItemPickupRange_area_entered(area):
	if (area.get_parent().has_method("start_followPlayer")):
		area.get_parent().start_followPlayer(self)

func sig_weapon_levelup(newLevel):
	emit_signal("weapon_levelup", newLevel)

func sig_weapon_xpGain(newXP, xpToLevelUp):
	emit_signal("weapon_xpGain", newXP, xpToLevelUp)


func _on_Weapon_toggle_useSubWeapon(bsubWeaponOn):
	bmoveSlow = bsubWeaponOn
	if (bmoveSlowOverride != bsubWeaponOn):
		bmoveSlowOverride = bsubWeaponOn
