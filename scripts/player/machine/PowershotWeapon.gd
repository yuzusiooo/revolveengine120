extends Node2D
# Weapon stats
# main Weapon
export var mainWeaponNode:Resource
export var mainFireRate:float = 0.0
var mainFireTimer:float = 0.0
var bMainFire:bool = true
var mainFirePoints:Array = []
export var mainWeaponSFX:AudioStream
# sub weapon
export var subWeaponNode:Resource
export var subFireRate:float = 0.0
export var subMainFireDelay:float = 0.5
export var subXPUse:float = 5.0
var bSubFire:bool = true
var subFireTimer:float = 0.0
var subMainFireDelayTimer:float = 0.0
var subFirePoints:Array = []
export var subWeaponSFX:AudioStream

# XP
var weaponLevel:int = 0
var weaponXP:float = 0
var nextLevelUpXP:Array = [30, 75]
# var bWeaponMaxLevel:bool = false
# var nextLevelUpXP:Array = [30, 75]
# export var WeaponLevelUpSFX:AudioStream

onready var MainWeapon = $MainWeapon
onready var SubWeapon = $SubWeapon

onready var MainWeaponSFX = $MainWeaponSFX
onready var SubWeaponSFX = $SubWeaponSFX
onready var LevelupSFX = $LevelupSFX

# SIGNAL
signal weapon_levelup(newLevel)
signal weapon_xpGain(newXP, xpToLevelUp)
signal toggle_useSubWeapon(bsubWeaponOn)

func process_weapon(delta):
	if (Input.get_action_strength("key_a")):
		fireMainWeapon(delta)
	if (Input.get_action_strength("key_b")):
		fireSubWeapon(delta)
	process_weaponCooldown(delta)

# XP AND LEVELING
func gain_xp(xpGain:float):
	weaponXP += xpGain
	update_weaponLevel()

func reset_XP():
	weaponXP = 0
	weaponLevel = 0
	set_mainFirePoints()
	emit_signal("weapon_levelup", weaponLevel)
	emit_signal("weapon_xpGain", weaponXP, nextLevelUpXP[weaponLevel])

# leveling should be fixed now?
func update_weaponLevel():
	if (weaponLevel == nextLevelUpXP.size()):
		print("level cap met")
		weaponXP = clamp(weaponXP, weaponXP, nextLevelUpXP[-1])
		emit_signal("weapon_xpGain", weaponXP, nextLevelUpXP[-1])
		return
	else:
		emit_signal("weapon_xpGain", weaponXP, nextLevelUpXP[weaponLevel])
		if (weaponXP >= nextLevelUpXP[weaponLevel]):
			weaponLevel += 1
			LevelupSFX.play(0.0)
			set_mainFirePoints()
			emit_signal("weapon_levelup", weaponLevel)

func update_weaponDelevel(delevelXP:float):
	weaponXP -= delevelXP
	clamp(weaponXP, 0, weaponXP)
	if (weaponLevel > 0):
		if (weaponXP < nextLevelUpXP[weaponLevel -1]):
			weaponLevel -= 1
			set_mainFirePoints()
			emit_signal("weapon_levelup", weaponLevel)
			emit_signal("weapon_xpGain", weaponXP, nextLevelUpXP[weaponLevel])

# WEAPON FIRING 
func process_weaponCooldown(delta):
	# main weapon cooldown
	if (!bMainFire):
		mainFireTimer -= delta
		if (mainFireTimer <= 0.0 && subMainFireDelayTimer <= 0):
			mainFireTimer = 0.0
			bMainFire = true
			# emit signal to stop force slow mode
			emit_signal("toggle_useSubWeapon", false)
	# sub weapon cooldown
	if (!bSubFire):
		subFireTimer -= delta
		subMainFireDelayTimer -= delta
		if (subFireTimer <= 0.0):
			subFireTimer = 0.0
			if (weaponXP >= subXPUse):
				bSubFire = true

func set_mainFirePoints():
	mainFirePoints.clear()
	mainFirePoints = MainWeapon.get_children()[weaponLevel].get_children()

func fireMainWeapon(delta):
	if (mainFirePoints.size() == 0):
		set_mainFirePoints()
	if (bMainFire):
		# fire weapon
		for firePoint in mainFirePoints:
			var bulletI = mainWeaponNode.instance()
			get_tree().get_current_scene().add_child(bulletI)
			bulletI.set_new(Vector2.RIGHT.rotated(self.rotation + firePoint.rotation), firePoint.global_position)
		if (MainWeaponSFX.stream == null): MainWeaponSFX.stream = mainWeaponSFX
		MainWeaponSFX.play(0.0)
		bMainFire = false
		mainFireTimer = 1/mainFireRate

func fireSubWeapon(delta):
	if (bSubFire):
		for firePoint in SubWeapon.get_children():
			var bulletI = subWeaponNode.instance()
			get_tree().get_current_scene().add_child(bulletI)
			bulletI.set_new(Vector2.RIGHT.rotated(self.rotation + firePoint.rotation), firePoint.global_position)
		# subtract XP
		update_weaponDelevel(subXPUse)
		if (SubWeaponSFX.stream == null): SubWeaponSFX.stream = subWeaponSFX
		SubWeaponSFX.play(0.0)
		bSubFire = false
		# start timer of subweapon and main delay
		subMainFireDelayTimer = subMainFireDelay
		subFireTimer = subFireRate
		emit_signal("toggle_useSubWeapon", true)
