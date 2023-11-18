extends Enemy

# movement
export var baseMovementDistance:float = 120
export var baseMoveTime:float = 0.5
var moveTime = baseMoveTime
var cMoveTime = 0
var deceleration:float = 50
# amount of times it will change position
export var TimesToChangeDirection:int = 3
var changeDirectionTimes:int = 0
var targetDirection
var bIsMoving:bool = false

# attack
export var tscnBullet:PackedScene
# how many bullets will be fired and the spread of the shot
export var multiShotCount:int
export var multiShotAngle:float = 90
# delay between finishing movement and attacking
export var AttackWaitTime:float = 0.5
var cAttackWaitTime:float
export var bulletSpeed:float = 300

# cooldown
export var cooldownTime:float = 1.0
var cCooldownTime:float

# Statemachine
enum EShotgunState{
    MoveNTimes,
    Attack,
    Cooldown
}

var currentState = EShotgunState.MoveNTimes

func process_movement(delta):
    pass

# func process_movement(delta):
#     match(currentState):
#         EShotgunState.MoveNTimes:
#             process_moveNtimes(delta)
#         EShotgunState.Attack:
#             process_attack(delta)
#         EShotgunState.Cooldown:
#             process_cooldown(delta)

# func process_moveNtimes(delta):
#     print("moving")
#     # set the target position to move based on the distance
#     if !bIsMoving and changeDirectionTimes < TimesToChangeDirection:
#         targetDirection = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()
#         cMoveTime = moveTime
#         bIsMoving = true
#     # count down the timer while allowing to move
#     if (bIsMoving and cMoveTime >= 0.0):
#         velocity = targetDirection
#         self.global_position += velocity * speed * delta
#         speed -= deceleration * delta
#         cMoveTime -= delta
#         # change state if it moved 3 times or reset bIsMoving
#         if (cMoveTime <= 0.0):
#             changeDirectionTimes += 1
#             bIsMoving = false
#             if (changeDirectionTimes == TimesToChangeDirection):
#                 currentState = EShotgunState.Attack
#                 cAttackWaitTime = AttackWaitTime

# func process_attack(delta):
#     print("attacking")
#     if (cAttackWaitTime >= 0.0):
#         cAttackWaitTime -= delta
#     if (cAttackWaitTime <= 0.0):
#         var bulletSpread = float(multiShotAngle / multiShotCount)
#         var initialAngle = -bulletSpread * (multiShotCount /2) 
#         for i in multiShotCount:
#             var iBullet = tscnBullet.instance()
#             get_tree().get_current_scene().add_child(iBullet)
#             var toPlayerVectorR = (Player.global_position - self.global_position).rotated(deg2rad(initialAngle + (bulletSpread * i)))
#             iBullet.set_new(self.global_position, toPlayerVectorR, self, bulletSpeed)
#         currentState = EShotgunState.Cooldown
#         cCooldownTime = cooldownTime

# func process_cooldown(delta):
#     if (cCooldownTime >= 0.0):
#         cCooldownTime -= delta
#         if (cCooldownTime <= 0.0):
#             currentState = EShotgunState.MoveNTimes
    