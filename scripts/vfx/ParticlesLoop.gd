extends vfxparticle

class_name vfxparticle_loop

onready var despawn:float = 5.0

func process_particles(delta):
	despawn -= delta
	if (despawn <= 0):
		queue_free()
