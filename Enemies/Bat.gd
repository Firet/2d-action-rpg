extends KinematicBody2D

var knockback = Vector2.ZERO

func _physics_process(delta):
	#  Bat has low friction because is in the air, 200 is a low number compared to the player's friction
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 120
	#queue_free()
