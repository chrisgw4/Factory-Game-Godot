extends GridContainer


var selected_button_index = -1
var dict:Dictionary = {0:"res://scenes/collectors/Auto-Collector.tscn", 1:"res://scenes/storage buildings/Base Storage.tscn", 2:"res://scenes/conveyors/Conveyor.tscn"}
var building_dict:Dictionary = {0:"Collector", 1:"Storage", 2:"Conveyor"}
onready var open_position = self.get_rect().position
onready var closed_position = self.get_rect().position+Vector2(150,0)
var closed = false

onready var factory_selector = self.get_parent().get_parent().get_node("GUI/BuildingSelectorBackground/ScrollContainer/Factory Selector")

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
			factory_selector.selected_button_index = -1
			#print(selected_button_index)
		index+=1

func _get_collector_type():
	#if selected_button_index == 1:
	#	return load("res://scenes/collectors/Auto-Collector.tscn")
	if selected_button_index != -1:
		return load(dict[selected_button_index])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
