extends Node2D

class_name vfxparticle

var vfxparticles = []
var args

func _ready():
	for i in get_children():
		if (i is Particles2D): vfxparticles.append(i)
	for i in vfxparticles:
		i.emitting = true

func _physics_process(delta):
	process_particles(delta)
	c_process_particles(delta)

# remove this node if all particles are not emitting
func process_particles(delta):
	for i in vfxparticles:
		if (i.emitting):
			return
		particle_end()
		queue_free()

# custom func that is ran every frame for particle scripts that extends this node
func c_process_particles(delta):
	pass

func set_new(newPos:Vector2, spawnArgs:Array = []):
	self.global_position = newPos
	args = spawnArgs
	c_set_new()

# func that is ran after set_new is called by the caller
func c_set_new():
	pass

# func that is ran after the particle finishes emitting
func particle_end():
	pass
