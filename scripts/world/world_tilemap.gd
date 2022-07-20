extends TileMap

var clicked_cell = null
var tile_center_pos = null

onready var factory_selector = get_parent().get_node("GUI/BuildingSelectorBackground/ScrollContainer/Factory Selector")
onready var collector_selector = self.get_parent().get_node("GUI/Collector Selector")
onready var first_change_var_input = get_parent().get_node("GUI/BuildingCodeBackground/FirstVar/FirstVarChangeInput")
onready var building_code_background = get_parent().get_node("GUI/BuildingCodeBackground")


onready var building_name_code_gui = get_parent().get_node("GUI/BuildingCodeBackground/Class/BuildingName")

onready var temp_buildings = get_parent().get_node("Temp-Buildings")

onready var camera = get_parent().get_node("Camera2D")

onready var chunk_tile_map = get_parent().get_child(0)






func _unhandled_input(event):
	chunk_tile_map = get_parent().get_child(0)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			# event.position works with the scaling of the window
			#self.clicked_cell = world_to_map(event.position+camera.global_position)
			#self.tile_center_pos = map_to_world(self.clicked_cell) + cell_size / 2
			get_tile_at_mouse_pos()
			# finds if an object is placed in the tile that is clicked
			for node in get_parent().get_node("Placed-Buildings").get_children():
				for placed_object in node.get_children():
					#if node.name == "Factories":
					
					# this line makes it so when you click anywhere not in a menu, it makes every "selected" part in the object = to false
					#placed_object.selected = false
					
			#for factory in get_parent().get_node("Placed-Buildings/Factories").get_children():
					if placed_object.entered and Input.is_action_just_pressed("click"):#placed_object.global_position.x-placed_object.size.x >= tile_center_pos.x and tile_center_pos.x <= placed_object.global_position.x+placed_object.size.x:#tile_center_pos > map_to_world(world_to_map(placed_object.global_position-placed_object.size)) and tile_center_pos < map_to_world(world_to_map(placed_object.global_position+placed_object.size)) : #world_to_map(placed_object.global_position - placed_object.size) <= world_to_map(tile_center_pos)  or world_to_map(tile_center_pos) >= world_to_map(placed_object.global_position+placed_object.size)  : #world_to_map(placed_object.global_position) == clicked_cell or #placed_object.global_position == self.tile_center_pos:
						
						# when a placed object in Placed-Buildings is clicked, it will update World scene to draw the radius and show gui
						placed_object.selected = !placed_object.selected
						
						
						building_code_background._change_first_var(placed_object.first_changeable_var)
						first_change_var_input.text = str(placed_object.production_speed)
						
						#building_code_background.visible = !building_code_background.visible
						building_name_code_gui.text = placed_object.building_name
						building_code_background.building = placed_object
						
						if placed_object.selected:
							building_code_background._start_tween_to_open()
						elif not placed_object.selected:
							building_code_background._start_tween_to_close()
						
						
						
						get_parent().update()
						
						for node2 in get_parent().get_node("Placed-Buildings").get_children():
							for placed_object2 in node2.get_children():
								if placed_object2 != placed_object:
									placed_object2.selected = false
							
						return
			
			
			if not "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)):
				if factory_selector.selected_button_index != -1:
					_spawn_building()
				
			

func _spawn_building():
	if factory_selector.selected_button_index == -1 or self.clicked_cell == null:
		return
		
	if(factory_selector.building_dict[factory_selector.selected_button_index] == "Factory"):
		var f = factory_selector._get_building_type()
		
		f = f.instance()
		f.global_position = self.tile_center_pos
		
		self.get_parent().get_node("Placed-Buildings/Factories").add_child(f)
		
	elif(factory_selector.building_dict[factory_selector.selected_button_index] == "Collector"):
		var f = factory_selector._get_building_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Auto-Collectors").add_child(f)
		
	elif (factory_selector.building_dict[factory_selector.selected_button_index] == "Storage"):
		var f = factory_selector._get_building_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Storages").add_child(f)
		
	elif (factory_selector.building_dict[factory_selector.selected_button_index] == "Conveyor"):
		var f = factory_selector._get_building_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Conveyors").add_child(f)



func _spawn_collector():
	if(self.clicked_cell != null and collector_selector.selected_button_index != -1 and collector_selector.building_dict[collector_selector.selected_button_index] == "Collector"):
		#self.get_cell(tile_map.clicked_cell.x, tile_map.clicked_cell.y)
		var f = collector_selector._get_collector_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Auto-Collectors").add_child(f)
	elif (self.clicked_cell != null and collector_selector.selected_button_index != -1 and collector_selector.building_dict[collector_selector.selected_button_index] == "Storage"):
		var f = collector_selector._get_collector_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Storages").add_child(f)
	elif (self.clicked_cell != null and collector_selector.selected_button_index != -1 and collector_selector.building_dict[collector_selector.selected_button_index] == "Conveyor"):
		var f = collector_selector._get_collector_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Conveyors").add_child(f)




func get_tile_at_mouse_pos():
	var mouse_coords = get_global_mouse_position()
	self.clicked_cell = world_to_map(mouse_coords)
	self.tile_center_pos = map_to_world(self.clicked_cell) + cell_size / 2
	

# spawns a temporary building, that gets removed every frame and re-added, to not allow spawning or collecting of the object, also shows where you're placing building
func spawn_temp_building():
	get_tile_at_mouse_pos()
	for node in get_parent().get_node("Placed-Buildings").get_children():
	#for num in range(0,2):
		#var node = get_parent().get_node("Placed-Buildings").get_child(num)
		for placed_object in node.get_children():
			if placed_object.global_position == self.tile_center_pos:
				return
	if factory_selector.selected_button_index != -1:
		var f = factory_selector._get_building_type().instance()
		f.global_position = self.tile_center_pos
		f.modulate = Color(0.552941, 0.552941, 0.552941, 0.290196)
		if "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)):
			f.modulate = Color(1, 0.203922, 0.203922, 0.454902)
		temp_buildings.add_child(f)
	#elif collector_selector.selected_button_index != -1:
	#	var f = collector_selector._get_collector_type().instance()
	#	f.global_position = self.tile_center_pos
	#	f.modulate = Color(0.552941, 0.552941, 0.552941, 0.290196)
	#	if "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)):
	#		f.modulate = Color(1, 0.427451, 0.427451, 0.482353)
	#	temp_buildings.add_child(f)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in temp_buildings.get_children():
		temp_buildings.remove_child(child)
	spawn_temp_building()
