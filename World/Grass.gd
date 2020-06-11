extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	# Assign the global position of Grass to the animated grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect() 
	# Disable hurbox to avoid hit multiple times (one hit kill)
	queue_free()
