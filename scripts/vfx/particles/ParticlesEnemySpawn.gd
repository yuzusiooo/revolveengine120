extends vfxparticle

# args = [waveManager node, enemy resource]

signal spawn_enemy(tscnEnemy)

func particle_end():
	connect("spawn_enemy", args[0], "particle_spawn_enemy")
	emit_signal("spawn_enemy", args[1], self.global_position)
	pass
