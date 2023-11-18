extends Node2D

class_name Pickup

var velocity:Vector2 = Vector2.ZERO
var currentSpeed: float = 0
var speed:float = 100
var deceleration:float = 1000
var scatterTime:float = 0.1

var bFollowPlayer:bool = false
var playerToFollow = null

# the value of this item in regards to xp, currency etc
export var value:float = 1.0
# the amount of score gained by picking up this item
export var scoreGain:float = 100

# pickup item that drops from the enemy
# scatters to a random direction when first spawned
# slowly move outside the screen after scattering stops
# do pickup stuff when colliding with player

func _physics_process(delta):
	if (velocity != null):
		if (!bFollowPlayer):
			process_itemDropMovement(delta)
		if (bFollowPlayer):
			process_playerFollowMovement(delta)

func process_itemDropMovement(delta):
	# set initial scatter speed
	if (scatterTime >= 0):
		scatterTime -= delta
		currentSpeed = speed * 2
	# if out of scatter time, decelerate until it matches the speed
	if (scatterTime <= 0):
		if (currentSpeed > speed):
			currentSpeed -= deceleration * delta
	self.global_position += (velocity * currentSpeed * delta)

func process_playerFollowMovement(delta):
	if (playerToFollow != null):
		velocity = (playerToFollow.global_position - self.global_position).normalized()
		self.global_position += velocity * speed * 5 * delta

func start_followPlayer(playerNode):
	playerToFollow = playerNode
	bFollowPlayer = true

func set_new(newPos:Vector2):
	self.global_position = newPos
	# set a random direction to move to
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
