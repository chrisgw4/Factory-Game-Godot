extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var factories = get_node("Placed-Buildings/Factories")
onready var collectors = get_node("Placed-Buildings/Auto-Collectors")
onready var resources = get_node("Resources")
onready var player = get_node("Player")
onready var resources_text = get_node("CanvasLayer/Resources_Label")
onready var tile_map = get_node("TileMap")
onready var camera = get_node("Camera2D")

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
			f.time_counter -= f.production_speed

func _collect_resources(mouse_coords:Vector2):
	var mouse_coords_camera_offset = mouse_coords#+camera.global_position
	for r in resources.get_children():
		if mouse_coords_camera_offset.distance_to(r.global_position) <= 5:
			r.queue_free()
			player.resources[r.resource_index] += 1
		elif mouse_coords_camera_offset.distance_to(r.global_position) <= 40:
			r.tween.interpolate_property(r, "position", r.global_position, mouse_coords_camera_offset, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		elif mouse_coords_camera_offset.distance_to(r.global_position) > 40:
			r.tween.interpolate_property(r, "position", r.global_position, r.go_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		
		for c in collectors.get_children():
			if (c.global_position.distance_to(r.global_position) <= c.collection_range):
				r.tween.interpolate_property(r, "position", r.global_position, c.global_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				r.tween.start()
				if c.global_position.distance_to(r.global_position) <= 5:
					r.queue_free()
					player.resources[r.resource_index] += 1
		

	
	
	
func _move_camera(delta:float):
	#if camera.position.x <= camera.limit_right and camera.position.x >= camera.limit_left and camera.position.y >= camera.limit_top and camera.position.y <= camera.limit_bottom:
	if Input.is_action_pressed("move_right"):
		camera.position.x += 200*delta
	if Input.is_action_pressed("move_left"):
		camera.position.x -= 200*delta
	if Input.is_action_pressed("move_down"):
		camera.position.y += 200*delta
	if Input.is_action_pressed("move_up"):
		camera.position.y -= 200*delta
	#print(str(camera.position.y+camera.get_viewport().size.y) + " " + str(camera.limit_bottom))
	
	# keeps the camera from getting offset dramatically when at the world borders
	if camera.position.y+camera.get_viewport().size.y >= camera.limit_bottom:
		camera.position.y = camera.limit_bottom-camera.get_viewport().size.y
	if camera.position.y <= camera.limit_top:
		camera.position.y = camera.limit_top
	if camera.position.x+camera.get_viewport().size.x >= camera.limit_right:
		camera.position.x = camera.limit_right-camera.get_viewport().size.x
	if camera.position.x <= camera.limit_left:
		camera.position.x = camera.limit_left
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_coords = get_local_mouse_position()#get_global_mouse_position()#get_viewport().get_mouse_position()
	
	#spawn_factory()
	_move_camera(delta)
	_collect_resources(mouse_coords)
	_update_factories(delta)
	
	resources_text.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Coal: " + str(player.resources[0]) + '\n' + "Iron: " + str(player.resources[1]) 
	resources_text.text += "\n" + "Coal On Screen: " + str(resources.get_child_count())
	#print(get_child_count())
	#print(player.resources[0])
	

