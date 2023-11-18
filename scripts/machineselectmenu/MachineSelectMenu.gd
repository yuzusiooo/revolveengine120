extends Node2D

export var machineList:Array
var selectedMachineIndex = 0

# CurrentMachine
# machine type, machine descriptor
onready var CurrentMachine = [$Control/CanvasLayer/MachineList/CurrentMachine/MachineType, $Control/CanvasLayer/MachineList/CurrentMachine/MachineDescriptor]
# MachineDetails
# machine name, main desc, sub desc
onready var MachineDetails = [$Control/CanvasLayer/SelectedMachine/MachineDetails/MachineName, $Control/CanvasLayer/SelectedMachine/MachineDetails/MainWeaponDesc, $Control/CanvasLayer/SelectedMachine/MachineDetails/SubWeaponDesc]

# MachineDemo
var CurrentMachineResource:Resource
onready var Demo_MainWeapon = $PlayerMachineDemo/MainWeapon
var bCanFireMain:bool = true
var mainFireRateTimer:float = 0.0
var mainFirePoints:Array = []
var mainWeaponNode:Resource
onready var MainWeaponSFX = $PlayerMachineDemo/MainWeaponSFX


onready var Demo_SubWeapon = $PlayerMachineDemo/SubWeapon
var bCanFireSub:bool = true
var subFireRateTimer:float = 0.0
var subAllowMainFireDelay:float = 0.5
var subAllowMainFireDelayTimer:float = 0.0
var subWeaponNode:Resource
onready var SubWeaponSFX = $PlayerMachineDemo/SubWeaponSFX


func _ready():
	update_selectedMachine(machineList[selectedMachineIndex])
	$Control/CanvasLayer/Navigation/ConfirmButton.grab_focus()

func _process(delta):
	process_menuScroll(delta)
	process_machineDemo(delta)

func update_selectedMachine(newMachineResource:playerMachineRes):
	CurrentMachineResource = newMachineResource
	CurrentMachine[0].text = newMachineResource.machineType
	CurrentMachine[1].text = newMachineResource.machineTypeDescriptor
	MachineDetails[0].text = newMachineResource.machineName
	MachineDetails[1].text = "Main: " + newMachineResource.mainWeaponDescription
	MachineDetails[2].text = "Sub: " + newMachineResource.subWeaponDescription
	
	mainWeaponNode = load(newMachineResource.mainWeaponNode)
	subWeaponNode = load(newMachineResource.subWeaponNode)

func process_menuScroll(delta):
	if (Input.is_action_just_released("key_down")):
		scroll_machineIndex(true)
	if (Input.is_action_just_released("key_up")):
		scroll_machineIndex(false)

func scroll_machineIndex(scroll_down):
	selectedMachineIndex + 1 if scroll_down else -1
	if (selectedMachineIndex >= machineList.size()) || (selectedMachineIndex <= machineList.size()):
		selectedMachineIndex = 0
	update_selectedMachine(machineList[selectedMachineIndex])

func _on_ReturnButton_pressed():
	get_tree().change_scene_to(Global.MainMenuScene)

func _on_ConfirmButton_pressed():
	Global.CurrentPlayerMachine = machineList[selectedMachineIndex]
	get_tree().change_scene_to(Global.MainGameScene)

func process_machineDemo(delta):
		# main gun cooldown
	if (!bCanFireMain):
		mainFireRateTimer -= delta
		if (mainFireRateTimer <= 0 && subAllowMainFireDelayTimer <= 0):
			mainFireRateTimer = 0.0
			bCanFireMain = true
	
	# sub gun cooldown
	if (!bCanFireSub):
		subFireRateTimer -= delta
		subAllowMainFireDelayTimer -= delta
		if (subFireRateTimer <= 0):
			subFireRateTimer = 0.0
			bCanFireSub = true
	
	# attempt to fire weapon
	demo_fireMain(delta)
	demo_fireSub(delta)

func demo_fireMain(delta):
	mainFirePoints = Demo_MainWeapon.get_children()
	if (bCanFireMain):
		for firePoint in mainFirePoints:
			var bulletI = mainWeaponNode.instance()
			get_tree().get_current_scene().add_child(bulletI)
			bulletI.set_new(Vector2.UP.rotated(self.rotation + firePoint.rotation), firePoint.global_position)
		MainWeaponSFX.stream = CurrentMachineResource.mainWeaponSFX
		MainWeaponSFX.play()
		bCanFireMain = false
		mainFireRateTimer = CurrentMachineResource.mainWeaponFireRate

func demo_fireSub(delta):
	if (bCanFireSub):
		for i in (CurrentMachineResource.subWeaponMultishot):
			var subBulletI = subWeaponNode.instance()
			get_tree().get_current_scene().add_child(subBulletI)
			var firePosition = Demo_SubWeapon.global_position
			firePosition.x -= (CurrentMachineResource.subWeaponMultishot/2 ) * 30
			firePosition.x += (30 * i)
			subBulletI.set_new(Vector2.UP.rotated(self.rotation), firePosition)
		SubWeaponSFX.stream = CurrentMachineResource.subWeaponSFX
		SubWeaponSFX.play()
		bCanFireSub = false
		subFireRateTimer = CurrentMachineResource.subWeaponFireRate
		subAllowMainFireDelayTimer = subAllowMainFireDelay
