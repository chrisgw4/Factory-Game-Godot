extends KinematicBody2D


var production_speed: float = 0

var produced_resource:String = ""

var time_counter: float = 0
var RNG = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawn_resource():
	if self.produced_resource == null:
		return
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
