extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
# Bat has low friction because is in the air, 
# 200 is a low number compared to the player's friction
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				# Subtract player position less enemy position. 
				# The center is position (0,0)
				# When is normalized and the velocity linked to 1. 
				var direction = (player.global_position - global_position).normalized()
				# Move towards the player. Magic!
				# Velocity in direction is 1 (because was normalized).
				# and then multiplied to max speed.
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else: 
				state = IDLE
				
			sprite.flip_h = velocity.x < 0


	velocity = move_and_slide(velocity)
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.createHitEffect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	# enemyDeathEffect is attach to the ysort (bat's parent)
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
