extends Node2D

class_name PlayerMainWeapon

var effectiveDistance:float = 192

func player_inEffectiveDistance(collider):
	return (Global.Main.Player.global_position.distance_to(collider.global_position) <= effectiveDistance)
