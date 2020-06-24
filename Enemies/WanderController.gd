extends Node2D

export(int) var wander_range = 32

# onready var because we want to get the position
# of this wander controller once it's already been
# instance inside of the room and it's attached 
# to the enemy (basically it's the enemy position)
onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	# Target position is always relative to start position
	# So never wander too far away from it
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
