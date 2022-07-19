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


func _draw():
	pass
	#if selected:
		#draw_circle_arc_poly(global_position, radius, 0, 360, Color(0.552941, 0.552941, 0.552941, 0.290196))
		#z_index = 0
	#else:
	#	z_index = -1
	
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"time_counter": time_counter
	}
	return save_dict
