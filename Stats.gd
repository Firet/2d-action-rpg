extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health
 
# This is a way to check for no health
# but its not performant, because it asking
# every frame about health, 
# its better using setters and getters
#func _process(delta):
#	if health <=0:
#		emit_signal("no_health")

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	# Check that actual health cannot ever
	# be larger than max health
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

# This function is created to solve the imposibility 
# to make health onready 
func _ready():
	self.health = max_health
