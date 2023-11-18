extends Camera2D

var Player
var Anchor

var cameraPosition:Vector2 = Vector2.ZERO

export(Vector2) var areaSize:Vector2 = Vector2(750, 750)
var minCameraZoom = 1.0
var maxCameraZoom = 1.3
var cameraZoomRate = 0.5
# going past this tolerance causes the camera to zoom out
var zoomoutTolerance = 0.6

# camera shake vars
var bCameraShake:bool = false
var camShake_duration:float
var camShake_time:float
var camShake_amount:float

# camera mode
enum CameraMode{
	Normal,
	Gameover
}
var cCameraMode = CameraMode.Normal

# gameover stuff
var bGameoverZoom = false
var targetZoom:Vector2 = Vector2.ONE

func _ready():
	pass

func init(Player, Anchor):
	self.Player = Player
	self.Anchor = Anchor
	pass

func _physics_process(delta):
	if (cCameraMode == CameraMode.Normal):
		process_camera_position(delta)
		process_camera_zoom(delta)
		process_camera_shake(delta)
	if (cCameraMode == CameraMode.Gameover):
		prorcess_camera_gameoverMode()

func process_camera_position(delta):
	# position the camera between the player and the anchor
	cameraPosition = get_center_camera_position()
	self.global_position = cameraPosition

func process_camera_zoom(delta):
	# get the rate between the player and the center of the screen
	var distToPlayerRate = (areaSize/2).distance_to(Player.global_position) / (areaSize/2).x
	# zoom in/out depending on how far the player is from the center
	if (distToPlayerRate >= zoomoutTolerance and zoom <= Vector2(maxCameraZoom, maxCameraZoom)):
		zoom += Vector2(cameraZoomRate, cameraZoomRate) * delta
	if (distToPlayerRate < zoomoutTolerance and zoom >= Vector2(minCameraZoom, minCameraZoom)):
		zoom -= Vector2(cameraZoomRate, cameraZoomRate) * delta

func start_camera_shake(shakeAmt:float, shakeDuration:float):
	bCameraShake = true
	camShake_duration = shakeDuration
	camShake_time = 0
	camShake_amount = shakeAmt

func process_camera_shake(delta):
	if (bCameraShake):
		camShake_time += delta
		var camShake_magitude = lerp(camShake_amount, 0, camShake_time/camShake_duration)
		cameraPosition = get_center_camera_position()
		cameraPosition.x += sin(camShake_time * (camShake_amount * camShake_amount)) * camShake_magitude
		if (camShake_time >= camShake_duration):
			bCameraShake = false
			cameraPosition = get_center_camera_position()
		self.global_position = cameraPosition

func get_center_camera_position():
	return (Player.global_position + Anchor.global_position)/2

func set_cameraMode(newCameraMode:String):
	match(newCameraMode.to_lower()):
		"normal":
			cCameraMode = CameraMode.Normal
		"gameover":
			cCameraMode = CameraMode.Gameover

func prorcess_camera_gameoverMode():
	# center point on player
	self.global_position = Player.global_position
	# zoom in
	if (!bGameoverZoom):
		targetZoom = Vector2(0.3, 0.3)
		if (zoom > targetZoom):
			zoom -= Vector2(0.1, 0.1) * get_physics_process_delta_time() * 3
	if (bGameoverZoom):
		targetZoom = Vector2(1.5, 1.5)
		if (zoom < targetZoom):
			zoom += Vector2(0.1, 0.1) * get_physics_process_delta_time() * 50

func _on_PlayerGameover_animation_ended():
	bGameoverZoom = true