extends Node2D


onready var factories = get_node("Placed-Buildings/Factories")
onready var collectors = get_node("Placed-Buildings/Auto-Collectors")
onready var storages = get_node("Placed-Buildings/Storages")
onready var resources = get_node("Resources")
onready var player = get_node("Player")
onready var resources_text = get_node("GUI/Resources_Label")
onready var camera = get_node("Camera2D")

onready var _building_code_background = get_node("GUI/BuildingCodeBackground")

onready var _chunk_tile_map = get_node("Chunk TileMap")

var _save: SaveGame


onready var tile_map:TileMap = get_node("TileMap")
var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
var cell_size:Vector2 = Vector2(32,32)
var width = 1024/cell_size.x
var height = 1024/cell_size.y


func _create_or_load_save():
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
	else:
		_save = SaveGame.new()
		
		_save.player_stats = PlayerStats.new()
		_save.camera_pos = camera.position
		#_save.factories = Factories.new()
		
		_save.write_savegame()
	
	camera.position = _save.camera_pos
	player.stats = _save.player_stats
	


func _save_game():
	_save.camera_pos = camera.position
	_save.write_savegame()


# Called when the node enters the scene tree for the first time.
func _ready():
	_create_or_load_save()
	
	#load_chunk_map()
	factories.load_factories()
	
	#_load_tile_world()




func _update_factories(delta:float):
	for f in factories.get_children():
		f.time_counter += delta
		
		if f.time_counter >= f.production_speed:
			if resources.get_child_count() < 8000:
				f.spawn_resource()
				f.time_counter -= f.production_speed



func _collect_resources(mouse_coords:Vector2, delta:float):
	var mouse_coords_camera_offset = mouse_coords #+camera.global_position
	for r in resources.get_children():
		#r.lifetime -= delta
		var dist = mouse_coords.distance_to(r.global_position)
		
		if  dist <= 5:
			r.queue_free()
			player.stats.collected_resources[r.resource_index] += r.stack
		elif dist <= 40:
			r.tween.interpolate_property(r, "position", r.global_position, mouse_coords, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		elif dist > 40 and r.global_position.distance_to(r.go_position) > 5:
			r.tween.interpolate_property(r, "position", r.global_position, r.go_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			r.tween.start()
		
		#if collectors.get_child_count() > 0:
		#	var closest_collector = collectors.get_children()[0]
		#	var closest_dist = closest_collector.global_position.distance_to(r.global_position)
		#	for c in collectors.get_children():
		#		if c.global_position.distance_to(r.global_position) < closest_dist:
		#			closest_collector = c
		#			closest_dist = c.global_position.distance_to(r.global_position)
		#	
		#	if (closest_dist <= closest_collector.collection_range):
		#		#r.tween.interpolate_property(r, "position", r.global_position, closest_collector.global_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#		#r.tween.start()
		#		if closest_collector.global_position.distance_to(r.global_position) <= 5:
		#			r.queue_free()
		#			closest_collector.resources[r.resource_index] += r.stack
					#player.resources[r.resource_index] += 1
		if r.lifetime < 10:
			r.modulate = Color(0.392157, 0.313726, 0.207843)#Color(1.0,1.0,1.0, 0.5)
		if r.lifetime < 0:
			r.queue_free()
		
		# STACKS RESOURCES
		#for r2 in resources.get_children():
		#	if r.global_position != r2.global_position && r.resource_name == r2.resource_name:
		#		if r.global_position.distance_to(r2.global_position) < 30:
		#			#print("OMG WOW")
		#			r2.queue_free()
		#			r2.tween.interpolate_property(r, "position", r2.global_position, r.global_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#			r2.stacking = true
		#			r.stack += r2.stack
		#			r.lifetime = r.base_lifetime
		#			return

func unselect_all():
	for node in get_node("Placed-Buildings").get_children():
		for n in node.get_children():
			n.selected = false
	$"GUI/BuildingSelectorBackground/ScrollContainer/Factory Selector".selected_button_index = -1
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_coords = get_local_mouse_position()#get_global_mouse_position()#get_viewport().get_mouse_position()
	
	camera.move_camera(delta)
	
	_collect_resources(mouse_coords, delta)
	
	_update_factories(delta)
	
	resources_text.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Coal: " + str(player.stats.collected_resources[0]) + '\n' + "Iron: " + str(player.stats.collected_resources[1]) 
	resources_text.text += "\n" + "Coal On Screen: " + str(resources.get_child_count())
	
	# UPDATE IS CALLED IN world_tilemap.gd
	
	if Input.is_action_just_pressed("ui_cancel"):
		unselect_all()
		


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



func _on_World_tree_exiting():
	pass
	#var packed_scene = PackedScene.new()
	#packed_scene.pack(get_child(0))
	#ResourceSaver.save("res://my_scene.tscn", packed_scene)
	_save_game()
	factories.save_factories()
	save_chunk_map()
	#print("OWEOIU")
	#_save_tile_world()
	#_save_game()
	#factories.save_factories()
	#save_chunk_map()
	
func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		pass
		#_save_game()
		#factories.save_factories()
		#save_chunk_map()


func save_chunk_map():
	var save_game = File.new()
	save_game.open("user://saves/chunk_map" + ".save", File.WRITE)
	
	var save_nodes = get_child(0)
	#print(save_nodes.size())
	#for i in save_nodes:
		#print(i.name)
	var node_data = save_nodes.save()
	save_game.store_line(to_json(node_data))
	
	save_game.close()

func load_chunk_map():
	"""
	Addapted from:
		https://docs.godotengine.org/en/3.1/tutorials/io/saving_games.html
	"""
	var save_game = File.new()
	if not save_game.file_exists("user://saves/chunk_map.save"):
		return # Error! We don't have a save to load.

	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://saves/chunk_map.save", File.READ)
   
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		
		"""
		Lines 37 & 38 are not in the documentation as of 03/10/19.
		They are necessary to avoid a null error. See:
			https://godotengine.org/qa/16807/godot-3-base-nill-while-parsing-json-file
		"""
		if current_line == null:
			continue
		
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instance()
		add_child(new_object)
		move_child(new_object, 0)
		print(new_object.get_position())
		#new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		#new_object.direction = Vector2(current_line["direction_x"], current_line["direction_y"])
		
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "direction_x" or i == "direction_y":
				continue
			new_object.set(i, current_line[i])
	print(str(get_child(0).noise_seed) + " SSDDS")
	save_game.close()

func _save_tile_world():
	print("DDD")
	var save_file = File.new()
	save_file.open("user://saves/tile_map.save", File.WRITE)
	
	var i = 0
	for chunk in get_child(0).get_used_cells():
		print(get_child(0).get_used_cells().size())
		print(i)
		save_file.store_double(chunk.x)
		save_file.store_double(chunk.y)
		i+=1
		for x in range(32):
			for y in range(32):
				save_file.store_8(get_child(0).get_cell(x+chunk.x*32, y+chunk.y*32))
	save_file.close()

func _load_tile_world():
	var save_file = File.new()
	if not save_file.file_exists("user://saves/tile_map.save"):
		return
	save_file.open("user://saves/tile_map.save", File.READ)
	
	while save_file.get_position() != save_file.get_len():
		var chunk = Vector2()
		chunk.x = save_file.get_double()
		chunk.y = save_file.get_double()
		#get_child(0).set_cellv(chunk, 0)
		for x in range(32):
			for y in range(32):
				get_child(0).set_cell(chunk.x*32+x, chunk.y*32+y, save_file.get_8())
	save_file.close()
