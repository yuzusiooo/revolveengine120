tool
extends MeshInstance

export(float, -1.0, 1.0) var blue_value = 1.0 setget update_blue
export(float) var mesh_height = 1.0 setget update_mesh_height

func update_blue(value):
	blue_value = value
#	material.set_shader_param("blue", blue_value)

func update_mesh_height(value):
	mesh_height = value
	mesh.material.set_shader_param("height_scale", mesh_height)
