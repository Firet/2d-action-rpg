extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
# Bat has low friction because it's in the air, 
# 200 is a low number compared to the player's friction
export var FRICTION = 200
# This is a variable that avoid moving around the point
# trying to be in the exact position. It has to be close to 0
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

# This is the initial state
# is reassigned in _ready()
var state = CHASE 

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

func _ready():
	pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()

		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
			accelerate_towards_point(wanderController.target_position, delta) 
			
			# This is a fix to bat moving around the relative point and not stay completely quiet
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
				
		CHASE:
			var player = playerDetectionZone.player
			if player != null: 
				accelerate_towards_point(player.global_position, delta) 			
			else: 
				state = IDLE
				
	# 400 is some value that push each bat that overlaps other soft collision area
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point) 
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	# Sprite point to the direction it's moving
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	# Add a timer with a random number between 1 and 3
	wanderController.start_wander_timer(rand_range(1,3))

# state_list is an array
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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
