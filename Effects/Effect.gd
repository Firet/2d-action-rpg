extends AnimatedSprite

func _ready():
	# self at the begining of line 6 is not mandatory in this case.
	# Connect signal animation_finished signal to function _on_animation_finished
	self.connect("animation_finished", self, "_on_animation_finished")
	# frame 0 is not needed, because it's already set in editor 
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
