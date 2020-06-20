extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

# Use invincivility to fix the bug 
# that bat can't hit player near a corner
var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func createHitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	# self is mandatory because is the only way to call set_invincible
	self.invincible = false

# Deactivating hurtbox when the player is invencible
func _on_Hurtbox_invincibility_started():
	# It can't set monitorable = false 
	# in the middle of the physics process.
	# Because of that I use set_defered
	set_deferred("monitorable", false)
	
# Activating hurtbox again when the player isn't invencible
func _on_Hurtbox_invincibility_ended():
	monitorable = true
