extends "res://scripts/Base_Building.gd"


var production_speed: float = 0

var produced_resource:String = ""

var time_counter: float = 0
var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
#var price = 0
var payment: String = ""

#var selected: bool = false




# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	self.radius = 40


func spawn_resource():
	if self.produced_resource == "":
		return
	
#func draw_circle_arc(center, radius, angle_from, angle_to, color):


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _draw():
	#if selected:
		#draw_circle_arc(self.position, 40, 0,0, Color(1.0,1.0,1.0))
