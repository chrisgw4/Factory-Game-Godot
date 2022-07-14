extends AnimatedSprite


var resource_name:String = ""
var resource_index = null
var go_position:Vector2 = Vector2(0,0)
var at_position:bool = false
onready var tween:Tween = get_child(0)
var sell_value:float = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
