extends AnimatedSprite


var resource_name: String = ""
var resource_index = null
var go_position = Vector2(0,0)
var at_position = false
var tween = get_child(0)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass