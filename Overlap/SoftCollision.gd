extends Area2D

# This soft collision works for bats that overlaps
# and seems they are only one.
# With this soft collision the move away
# from each other.
# This isn't recomendable if 
# its going to be hundreds of enemies at the same time

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		# Get the first area that collide
		# If collide with 2 areas, 
		# its going to move away from one of them
		# In the end move away from each other
		var area = areas[0]
		# get a vector from that goes from its position
		# to our position
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	# returns 0 if it's not colliding with anything
	return push_vector
