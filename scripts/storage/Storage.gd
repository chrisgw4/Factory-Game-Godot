extends "res://scripts/Base_Building.gd"


var resources:Array = [0,0,0,0,0]
onready var text = get_node("Node2D/RichTextLabel")

var resources_dict:Dictionary = {0:"Coal", 1:"Iron", 2:"Null", 3:"Null", 4:"Null"}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.radius = 20


func _show_resources_held():
	text.visible = true
	text.text = ""
	for r in resources_dict:
		text.text += resources_dict[r] + ": " + str(resources[r]) + "\n"
		

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
