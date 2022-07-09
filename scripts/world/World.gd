extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var factories = get_node("Factories")
onready var resources = get_node("Resources")
onready var player = get_node("Player")
onready var resources_text = get_node("CanvasLayer/Resources_Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	#var tween = get_child(1).get_node("Tween")
	
	#tween.interpolate_property(get_child(1), "position",
	#	get_child(0).global_position, get_child(1).go_position, 1,
	#	Tween.TRANS_LINEAR)
	#tween.start()
	
func _update_factories(delta:float):
	for f in factories.get_children():
		f.time_counter += delta
		
		if f.time_counter >= f.production_speed:
			f.spawn_resource()
			f.time_counter = 0

func _collect_resources(delta:float, mouse_coords:Vector2):
	for r in resources.get_children():
		if mouse_coords.distance_to(r.global_position) <= 5:
			r.queue_free()
			player.resources[r.resource_index] += 1
		elif mouse_coords.distance_to(r.global_position) <= 40:
			r.tween.interpolate_property(r, "position", r.global_position, mouse_coords, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		elif mouse_coords.distance_to(r.global_position) > 40:
			r.tween.interpolate_property(r, "position", r.global_position, r.go_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_coords = get_viewport().get_mouse_position()
	_collect_resources(delta, mouse_coords)
	_update_factories(delta)
	
	resources_text.text = "Coal: " + str(player.resources[0]) + '\n' + "Iron: " + str(player.resources[1]) 
	
	#print(get_child_count())
	#print(player.resources[0])
	
	
