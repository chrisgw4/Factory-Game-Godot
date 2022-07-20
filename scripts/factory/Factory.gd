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
	self.building_name = "Factory"
	first_changeable_var = "production_speed"
	self.change_var_dict = {"firstvar":"production_speed"}
	tile_rows = 1
	tile_cols = 1
	


func spawn_resource():
	if self.produced_resource == "":
		return
	

func save():
	var save_dict = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"time_counter": time_counter,
		"production_speed":production_speed,
		"tiles_placed_on_x":tiles_placed_on_x,
		"tiles_placed_on_y":tiles_placed_on_y,
	}
	print(tiles_placed_on_y)
	return save_dict
