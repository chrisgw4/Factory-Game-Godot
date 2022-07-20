extends GridContainer


var selected_button_index:int = -1

var dict:Dictionary = {0:"res://scenes/factory/coal_factory/Coal_Factory.tscn", 1:"res://scenes/collectors/Auto-Collector.tscn", 2:"res://scenes/storage buildings/Base Storage.tscn", 3:"res://scenes/conveyors/Conveyor.tscn", 4:"res://scenes/hub/Hub.tscn"}
var building_dict:Dictionary = {0:"Factory", 1:"Collector", 2:"Storage", 3:"Conveyor", 4:"Hub"}
onready var open_position = self.get_rect().position
#onready var closed_position = self.get_rect().position+Vector2(150,0)
var closed:bool = false

#onready var collector_selector = self.get_parent().get_parent().get_parent().get_node("Collector Selector")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	var index = 0
	for child in get_children():
		if child.get_class() == "Tween":
			break
		if child.pressed:
			selected_button_index = index
			if not get_parent().get_parent().tween.is_active():
				get_parent().get_parent()._start_tween_to_close()
		index+=1
	

func _get_building_type():
	#if selected_button_index == 1:
	#	return load("res://scenes/collectors/Auto-Collector.tscn")
	if selected_button_index != -1:
		return load(dict[selected_button_index])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
