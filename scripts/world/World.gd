extends Node2D


onready var factories = get_node("Placed-Buildings/Factories")
onready var collectors = get_node("Placed-Buildings/Auto-Collectors")
onready var storages = get_node("Placed-Buildings/Storages")
onready var resources = get_node("Resources")
onready var player = get_node("Player")
onready var resources_text = get_node("CanvasLayer/Resources_Label")
onready var camera = get_node("Camera2D")



onready var tile_map:TileMap = get_node("TileMap")
var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
var cell_size:Vector2 = Vector2(32,32)
var width = 1024/cell_size.x
var height = 1024/cell_size.y
var grid = []

var Tiles = {"empty":-1, "grass":0, "sand":1, "water":2}

func _init_grid():
	grid = []
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(-1)

func GetRandomDirection():
	var directions = [[-1,0],[1,0],[0,1],[0,-1]]
	var direction = directions[RNG.randi()%4]
	return Vector2(direction[0], direction[1])

func _create_random_path():
	pass

func _spawn_tiles():
	for x in width:
		for y in height:
			match grid[x][y]:
				Tiles.empty:
					pass
				Tiles.floor:
					tile_map.set_cellv(Vector2(x,y), 0)
				Tiles.water:
					pass



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



func _collect_resources(mouse_coords:Vector2, delta:float):
	var mouse_coords_camera_offset = mouse_coords#+camera.global_position
	for r in resources.get_children():
		r.lifetime -= delta
		
		if mouse_coords_camera_offset.distance_to(r.global_position) <= 5:
			r.queue_free()
			player.resources[r.resource_index] += 1
		elif mouse_coords_camera_offset.distance_to(r.global_position) <= 40:
			r.tween.interpolate_property(r, "position", r.global_position, mouse_coords_camera_offset, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
			
			# add a break if you want to make it collect only one at a time
			#break
			
		elif mouse_coords_camera_offset.distance_to(r.global_position) > 40:
			r.tween.interpolate_property(r, "position", r.global_position, r.go_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		
		if collectors.get_child_count() > 0:
			var closest_collector = collectors.get_children()[0]
			for c in collectors.get_children():
				if c.global_position.distance_to(r.global_position) < closest_collector.global_position.distance_to(r.global_position):
					closest_collector = c
			
			if (closest_collector.global_position.distance_to(r.global_position) <= closest_collector.collection_range):
				r.tween.interpolate_property(r, "position", r.global_position, closest_collector.global_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				r.tween.start()
				if closest_collector.global_position.distance_to(r.global_position) <= 5:
					r.queue_free()
					closest_collector.resources[r.resource_index] += 1
					#player.resources[r.resource_index] += 1
		if r.lifetime < 10:
			r.modulate = Color(1.0,1.0,1.0)
		if r.lifetime < 0:
			r.queue_free()

func unselect_all():
	for node in get_node("Placed-Buildings").get_children():
		for n in node.get_children():
			n.selected = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_coords = get_local_mouse_position()#get_global_mouse_position()#get_viewport().get_mouse_position()
	
	camera.set_limit_drawing_enabled(true)
	camera.move_camera(delta)
	
	_collect_resources(mouse_coords, delta)
	_update_factories(delta)
	
	resources_text.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Coal: " + str(player.resources[0]) + '\n' + "Iron: " + str(player.resources[1]) 
	resources_text.text += "\n" + "Coal On Screen: " + str(resources.get_child_count())
	update()
	
	if Input.is_action_just_pressed("ui_cancel"):
		unselect_all()
	#print(get_child_count())
	#print(player.resources[0])
	
func _draw():
	for f in factories.get_children():
		if f.selected:
			f.z_index = 0
			draw_circle_arc_poly(f.global_position, f.radius, 0, 360, Color(0.552941, 0.552941, 0.552941, 0.290196))
		elif not f.selected:
			f.z_index = -1
	for c in collectors.get_children():
		if c.selected:
			c.z_index = 0
			
			var screen_width = ProjectSettings.get_setting("display/window/size/width")
			var screen_height = ProjectSettings.get_setting("display/window/size/height")
	
			c.get_node("Node2D").global_position = c.global_position
			c._show_resources_collected()
			if not c.get_node("AnimationPlayer").is_playing():
				c.get_node("AnimationPlayer").play("selected")
			
			draw_circle_arc_poly(c.global_position, c.radius, 0, 360, Color(0.552941, 0.552941, 0.552941, 0.290196))
			#c.scale = c.base_scale*2
		elif c.text.visible and not c.selected:
			c.z_index = -1
			c.text.visible = false
			c.get_node("AnimationPlayer").play("RESET")
			
			#c.scale = c.base_scale
	
	for s in storages.get_children():
		if s.selected:
			s.z_index = 0
			
			s.get_node("Node2D").global_position = s.global_position
			s._show_resources_held()
			draw_circle_arc_poly(s.global_position, s.radius, 0, 360, Color(0.552941, 0.552941, 0.552941, 0.290196))
		elif s.text.visible and not s.selected:
			s.z_index  -1
			s.text.visible = false

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
