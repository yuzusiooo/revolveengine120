extends PlayerMachine

onready var Weapon = $Weapon
onready var SpriteAnchor = $SpriteAnchor
onready var PlayerSprite = $SpriteAnchor/Sprite
onready var Anim = $SpriteAnchor/AnimationPlayer

var playerShadowtscn = preload("res://nodes/player/PlayerShadow.tscn")

func process_PlayerMachine(delta):
	Weapon.process_weapon(delta)

func process_Rotation(newRadians:float):
	SpriteAnchor.rotation = newRadians
	Weapon.rotation = newRadians

func pickup_weaponGem(value:float):
	Weapon.gain_xp(value)

func play_animation(animName:String, looping:bool = false):
	if (Anim.current_animation != animName):
		Anim.play(animName)

func process_shadow(velocity:Vector2):
	if (velocity != Vector2.ZERO):
		var playerShadowI = playerShadowtscn.instance()
		get_tree().get_current_scene().add_child(playerShadowI)
		playerShadowI.set_new(self.global_position, SpriteAnchor.rotation, PlayerSprite.texture, [PlayerSprite.hframes, PlayerSprite.vframes], PlayerSprite.frame)

func player_dead():
	Anim.play("dyingAnim")
