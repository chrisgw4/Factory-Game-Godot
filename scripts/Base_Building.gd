extends KinematicBody2D


var selected:bool = false
var price:float = 0.0
var radius: int = 0
var entered = false
var building_name = ""

var first_changeable_var = ""
var first_var_desc = ""

var tiles_placed_on_x:Array = []
var tiles_placed_on_y:Array = []
var tiles_occupied_by_self = []
var tile_rows = 0
var tile_cols = 0

# dictionary holding variable values for the coding segment of game
var var_dict: Dictionary = {}

var change_var_dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _process(delta):
	if tiles_occupied_by_self.size() == 0:
		for i in tiles_placed_on_x.size():
			tiles_occupied_by_self.append(Vector2(tiles_placed_on_x[i], tiles_placed_on_y[i]))
	_update_var_dict()

func _update_var_dict():
	pass
