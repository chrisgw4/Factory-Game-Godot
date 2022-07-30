extends "res://scripts/Base_Building.gd"


var production_speed: float = 0

var produced_resource:String = ""

var time_counter: float = 0
var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
#var price = 0
var payment: String = ""


# increments the time counter and when it reaches the production time it will spew out a resource
func _update_time_counter(delta):
	time_counter += delta
		
	if time_counter >= production_speed:
		if get_parent().get_parent().get_parent().get_node("Resources").get_child_count() < 8000:
			spawn_resource()
			time_counter -= production_speed


func _process(delta):
	_update_time_counter(delta)




# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	self.radius = 40
	self.building_name = "Factory"
	first_changeable_var = "production_speed"
	self.change_var_dict = {"firstvar":"production_speed"}
	tile_rows = 1
	tile_cols = 1
	

func _update_var_dict():
	self.var_dict = {0:production_speed}

# spawns the produced resource after time counter reaches/surpasses the production speed and spawn the resource in a radius around the building
func spawn_resource():
	if self.produced_resource == "":
		return
	if self.produced_resource == null:
		return
	self.RNG.randomize()
	
	var res = load(produced_resource)
	var resource = res.instance()
	
	var tween = resource.get_node("Tween")
	
	while resource.go_position == Vector2(0,0) or self.global_position.distance_to(resource.go_position) > 40:
		resource.go_position.x = self.global_position.x+RNG.randi_range(-self.radius,self.radius)
		resource.go_position.y = self.global_position.y+RNG.randi_range(-self.radius,self.radius)
	
	resource.global_position = self.global_position
	
	#tween.interpolate_property(resource, "position",
	#	self.global_position, resource.go_position, .05,
	#	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	
	self.get_parent().get_parent().get_parent().get_node("Resources").add_child(resource)
	
	resource.tween.interpolate_property(resource, "position",
		self.global_position, resource.go_position, .15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	

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
	return save_dict
