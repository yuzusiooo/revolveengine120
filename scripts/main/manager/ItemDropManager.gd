extends Node2D

# just holds a reference to all the items that can be dropped in a dictionary

onready var itemList = {
	"WeaponGem" : preload("res://nodes/item/WeaponGem.tscn"),
	"Medal" : preload("res://nodes/item/Medal.tscn")
}

func get_itemResource(itemName:String):
	if (itemList.has(itemName)):
		return (itemList.get(itemName))
	else:
		return null
