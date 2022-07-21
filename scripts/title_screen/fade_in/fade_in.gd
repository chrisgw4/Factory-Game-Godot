extends ColorRect


signal fade_finished

func fade_in():
	$AnimationPlayer.play("fade_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


