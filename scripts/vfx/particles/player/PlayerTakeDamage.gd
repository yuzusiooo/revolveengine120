extends vfxparticle

func c_process_particles(delta):
	self.global_position = args[0].global_position
