extends Node

var weaponLevel:int = 0
var weaponXP:float = 0
var nextLevelUpXP:Array = [30, 75]
export var WeaponLevelUpSFX:AudioStream

onready var MainWeaponSFX = $MainWeaponSFX
onready var SubWeaponSFX = $SubWeaponSFX
onready var LevelUpSFX = $LevelUpSFX

# weapon stats can be moved to playerMachine resources instead
var machineWeapon:playerMachineRes = null
export var machineWeapon_backup:Resource

onready var Main = $MainWeapon
var bCanFireMain:bool = true
var mainFireRateTimer:float = 0.0
var mainFirePoints:Array = []
var mainWeaponNode:Resource

onready var Sub = $SubWeapon
var bCanFireSub:bool = true
var subFireRateTimer:float = 0.0
var subAllowMainFireDelay:float = 0.5
var subAllowMainFireDelayTimer:float = 0.0
var subWeaponNode:Resource
var subFirePoints:Array = []

signal need_weapon(weaponNode)
signal weapon_levelup(newLevel)
signal update_weaponLevel(xpAmount)
signal toggle_useSubweapon(busing)

func process_weapon(delta):
	# request weapon until it can fire
	if (machineWeapon == null):
		emit_signal("need_weapon", self)
		machineWeapon = machineWeapon_backup
		return
	if (mainWeaponNode == null) || (subWeaponNode == null):
		mainWeaponNode = load(machineWeapon.mainWeaponNode)
		subWeaponNode = load(machineWeapon.subWeaponNode)
	# main gun cooldown
	if (!bCanFireMain):
		mainFireRateTimer -= delta
		if (mainFireRateTimer <= 0 && subAllowMainFireDelayTimer <= 0):
			mainFireRateTimer = 0.0
			bCanFireMain = true
			emit_signal("toggle_useSubweapon", false)
	
	# sub gun cooldown
	if (!bCanFireSub):
		subFireRateTimer -= delta
		subAllowMainFireDelayTimer -= delta
		if (subFireRateTimer <= 0):
			subFireRateTimer = 0.0
			if (weaponXP > machineWeapon.subWeaponXPUse):
				bCanFireSub = true

func pickup_weaponGem(XPGain:float):
	weaponXP += XPGain
	update_weaponLevel()

func update_weaponLevel():
	# check if it has not met the level cap
#	if (weaponLevel >= nextLevelUpXP.size()):
#		return
	# valid level up
	if (weaponLevel < nextLevelUpXP.size()):
		if (weaponXP >= nextLevelUpXP[weaponLevel]):
			# level up, play VSFX, update the firepoints
			weaponLevel += 1
			LevelUpSFX.play(0.0)
			set_mainFirePoints()
			emit_signal("weapon_levelup", weaponLevel)
	# update weapon level info to the HUD
	emit_signal("update_weaponLevel", weaponXP)

# used when actions that reduce the weapon XP are used (sub weapon)
func update_weaponDelevel(delevelXP:float = 0):
	if (delevelXP != 0):
		weaponXP -= delevelXP
		clamp(weaponXP, 0, weaponXP)
	if (weaponLevel > 0):
		if (weaponXP < nextLevelUpXP[weaponLevel -1]):
			weaponLevel -= 1
			set_mainFirePoints()
			emit_signal("weapon_levelup", weaponLevel)
	emit_signal("update_weaponLevel", weaponXP)

func set_mainFirePoints():
	mainFirePoints.clear()
	mainFirePoints = Main.get_children()[weaponLevel].get_children()

func fire_mainWeapon(delta):
	if (mainFirePoints.size() <= 0): set_mainFirePoints() 
	# spawn a bulet from each of the mainFirePoints
	if (bCanFireMain):
		for firePoint in mainFirePoints:
			var bulletI = mainWeaponNode.instance()
			get_tree().get_current_scene().add_child(bulletI)
			bulletI.set_new(Vector2.RIGHT.rotated(self.rotation + firePoint.rotation), firePoint.global_position)
		MainWeaponSFX.stream = machineWeapon.mainWeaponSFX
		MainWeaponSFX.play()
		bCanFireMain = false
		mainFireRateTimer = machineWeapon.mainWeaponFireRate

func fire_subWeapon(delta):
	if (bCanFireSub):
		for i in(machineWeapon.subWeaponMultishot):
			var subBulletI = subWeaponNode.instance()
			get_tree().get_current_scene().add_child(subBulletI)
			var firePosition = Sub.global_position
			firePosition.x -= (machineWeapon.subWeaponMultishot/2 ) * 30
			firePosition.x += (30 * i)
			subBulletI.set_new(Vector2.RIGHT.rotated(self.rotation), firePosition)
		# subtract XP
		update_weaponDelevel(machineWeapon.subWeaponXPUse)
		# play subweapon sound
		SubWeaponSFX.stream = machineWeapon.subWeaponSFX
		SubWeaponSFX.play()
		bCanFireSub = false
		# subweapon firerate
		subFireRateTimer = machineWeapon.subWeaponFireRate
		subAllowMainFireDelayTimer = subAllowMainFireDelay
		# emit signal to player
		emit_signal("toggle_useSubweapon", true)
