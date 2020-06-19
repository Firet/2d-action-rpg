extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health
 
# This is a way to check for no health
# but its not performant, because it asking
# every frame about health, 
# its better using setters and getters
#func _process(delta):
#	if health <=0:
#		emit_signal("no_health")

signal no_health


func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
