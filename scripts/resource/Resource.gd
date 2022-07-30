extends AnimatedSprite


var resource_name:String = ""
var resource_index = null
var go_position:Vector2 = Vector2(0,0)
var at_position:bool = false
onready var tween:Tween = get_child(0)
var sell_value:float = 0
var lifetime = 20
var base_lifetime = 20

var stacking:bool = false

var stack = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_collect_resources(delta)
	pass

func _collect_resources(delta:float):
	var mouse_pos = get_global_mouse_position() #+camera.global_position
	#r.lifetime -= delta
	var dist = mouse_pos.distance_to(global_position)
	
	if  dist <= 5:
		queue_free()
		get_parent().get_parent().get_node("Player").stats.collected_resources[resource_index] += stack
	
	# check if tween is active to let reduce lag and it will complete its move before starting another
	elif dist <= 40 and not tween.is_active():
		tween.interpolate_property(self, "position", global_position, mouse_pos, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif dist > 40 and global_position.distance_to(go_position) > 5 and not tween.is_active():
		tween.interpolate_property(self, "position", global_position, go_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	
	if lifetime < 10:
		modulate = Color(0.392157, 0.313726, 0.207843)#Color(1.0,1.0,1.0, 0.5)
	if lifetime < 0:
		queue_free()


func _on_Tween_tween_all_completed():
	if stacking:
		pass
