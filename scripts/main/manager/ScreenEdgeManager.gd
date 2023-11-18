extends Node2D

onready var warningSound = $AudioStreamPlayer
onready var borderSprite = $Control/CanvasLayer/Sprite
export var blinkTime:float = 1.0
var cblinkTime = 0.0

export var sndWarning:AudioStream
export var sndWarningFast:AudioStream

func border_blink(speedMultiplier:float = 1.0):
    print(cblinkTime)
    if (cblinkTime <= 0.0):
        cblinkTime = blinkTime
    borderSprite.modulate.a = lerp(1, 0, (cblinkTime / blinkTime))
    cblinkTime -= get_physics_process_delta_time() * speedMultiplier
    play_warningSound(speedMultiplier > 1.0)

func play_warningSound(bfast:bool = false):
    warningSound.stream = sndWarningFast if bfast else sndWarning
    if (!warningSound.playing):
        warningSound.play()

func border_reset():
    cblinkTime = 0.0
    borderSprite.modulate.a = 0.0
    warningSound.stop()