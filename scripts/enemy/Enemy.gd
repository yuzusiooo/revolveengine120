extends Node2D

class_name Enemy

export var hp:float = 2.0
export var speed:float = 50
var velocity:Vector2 = Vector2.ZERO

# score gained by defeating this enemy
export var scoreGain:float = 100

var Player

var despawnTimer:float = 10.0

# amount of item drop rolls this enemy will attempt on death
export var itemDropRolls:int = 4
# drop rate of the item to the String name of the item
export var itemDropTable = [
	[3.0, "WeaponGem"],
	[4.0, "Medal"],
	[5.0, "None"]
]

var bLockedOn:bool = false

# sounds
export var HitSFX:NodePath
export var HitSFX_Stream:AudioStream
export var DeadSFX_Stream:AudioStream
export var AttackSFX:NodePath
export var AttackSFX_Stream:AudioStream

# VFX
var singleExplosionVFX = preload("res://nodes/vfx/particles/SingleExplosion.tscn")

# Taking damage
var bFlashOn:bool = false
var flashTimer:float = 0.2
const cFlashTime:float = 0.1

func _ready():
	pass

func _physics_process(delta):
	process_movement(delta)
	process_attack(delta)
	process_despawn(delta)
	process_shader(delta)
	pass

# set the position that this enemy will spawn at and the player node
func set_new(newPos:Vector2):
	self.global_position = newPos
	Player = Global.Main.Player
	set_new_class()

# abstract function that is called after set_new()
func set_new_class():
	pass

# abstract function for processing movement
func process_movement(delta):
	pass

# abstract function for processing attack
func process_attack(delta):
	pass

func process_shader(delta):
	# change this bit so that it changes every single Sprite node
	if (bFlashOn):
		var SpriteAnchorChildren = $SpriteAnchor.get_children()
		for i in SpriteAnchorChildren:
			if (i.get_class() == "Sprite"):
				i.material.set_shader_param("bFlashOn", true)
		flashTimer -= delta
		if (flashTimer <= 0.0):
			for i in SpriteAnchorChildren:
				if (i.get_class() == "Sprite"):
					i.material.set_shader_param("bFlashOn", false)
			flashTimer = 0.0
			bFlashOn = false

# taking damage, called by the weapon/bullet colliding with this enemy
func take_damage(damage):
	hp -= damage
	SFX_play("HitSFX", HitSFX_Stream)
	bFlashOn = true
	flashTimer = cFlashTime
	if (hp <= 0):
		enemy_dead()

func enemy_dead():
	# play dead sound and VFX
	SFX_play("HitSFX", DeadSFX_Stream)
	var explosionVFXI = singleExplosionVFX.instance()
	get_tree().get_current_scene().add_child(explosionVFXI)
	explosionVFXI.set_new(self.global_position)
	# spawn items that this enemy should drop
	drop_items()
	# add score
	Global.Main.ScoreManager.add_score(scoreGain, self.global_position)
	queue_free()

func drop_items():
	for dropRoll in itemDropRolls:
		# get the total weight of all items that this enemy drops
		var totalWeight:float = 0
		for i in itemDropTable: totalWeight += i[0]
		# roll for a random float
		var roll = rand_range(0, totalWeight)
		# check which item it should drop
		for i in itemDropTable.size():
			# minrange = the minimum roll
			var minRange = 0 if (i == 0) else (itemDropTable[i - 1][0])
			# maxrange = the max roll of item
			# minrange should be added because it start where the last maxRange left off
			var maxRange = itemDropTable[i][0] + minRange
			# spawn the appropriate item if a roll is between the set range
			if (roll > minRange and roll < maxRange):
				# get the resource from the item drop manager
				var itemDrop = Global.Main.ItemDropManager.get_itemResource(itemDropTable[i][1])
				if (itemDrop != null):
					# spawn item drop
					var itemDrop_i = itemDrop.instance()
					get_tree().get_current_scene().call_deferred("add_child", itemDrop_i)
					itemDrop_i.set_new(self.global_position)
					return

func SFX_play(target:String, newStream:AudioStream):
	match(target):
		"HitSFX":
			# need to run extra check if the Stream is the dead one here
			# so that it spawns a oneshot node instead of playing within itself
			if (newStream == DeadSFX_Stream):
				var sfxI = Global.SFXOneShot.instance()
				get_tree().get_current_scene().add_child(sfxI)
				sfxI.set_new(self.global_position, DeadSFX_Stream)
				return
			if (HitSFX):
				get_node(HitSFX).stream = newStream
				get_node(HitSFX).play(0.0)


func process_despawn(delta):
	despawnTimer -= delta
	if (despawnTimer <= 0):
		queue_free()
