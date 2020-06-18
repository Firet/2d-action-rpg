extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
# the $ sing is a shorthand to getting access to a node in the three
# that is part of the same scene 
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

		ROLL: 
			roll_state(delta)

		ATTACK: 
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle") 
		velocity =  velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(delta):
	# While rolling increase velocity
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

# warning-ignore:unused_argument
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	# Next four lines are different options to avoid keep accelerating after rolling
	# velocity = Vector2.ZERO
	# velocity = velocity / 2
	# velocity = velocity * 0.3
	# velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE	
