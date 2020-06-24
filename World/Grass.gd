extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	# grassEffect is attached to Grass node
	# (which is the parent of all individual grass nodes)
	get_parent().add_child(grassEffect)
	# Assign the global position of Grass to the animated grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	create_grass_effect() 
	# Disable hurbox to avoid hit multiple times (one hit kill)
	queue_free()
