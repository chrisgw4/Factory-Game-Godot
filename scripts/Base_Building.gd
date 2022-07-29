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
var tile_rows = 0
var tile_cols = 0

var change_var_dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



