extends "res://scripts/Base_Building.gd"





# Called when the node enters the scene tree for the first time.
func _ready():
	tile_rows = 3
	tile_cols = 3
	self.change_var_dict = {"firstvar":"position.x"}


func _update_var_dict():
	self.var_dict = {0:position.x}
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func save():
	var save_dict = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"tiles_placed_on_x":tiles_placed_on_x,
		"tiles_placed_on_y":tiles_placed_on_y,
	}
	return save_dict
