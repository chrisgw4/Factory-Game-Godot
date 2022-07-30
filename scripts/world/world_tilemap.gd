extends TileMap

var clicked_cell = null
var tile_center_pos = null

onready var factory_selector = get_parent().get_node("GUI/BuildingSelectorBackground/ScrollContainer/Factory Selector")
onready var collector_selector = self.get_parent().get_node("GUI/Collector Selector")
onready var first_change_var_input = get_parent().get_node("GUI/BuildingCodeBackground/VBoxContainer/Variable/VariableInput")
onready var building_code_background = get_parent().get_node("GUI/BuildingCodeBackground")


onready var building_name_code_gui = get_parent().get_node("GUI/BuildingCodeBackground/Class")

onready var temp_buildings = get_parent().get_node("Temp-Buildings")

onready var camera = get_parent().get_node("Camera2D")

onready var chunk_tile_map = get_parent().get_child(0)

var tile_size_dict:Dictionary = {"Factory":Vector2(1,1), "Hub":Vector2(3,3)}

var temp_building_red = false
var stop = false



func _unhandled_input(event):
	chunk_tile_map = get_parent().get_child(0)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			temp_building_red = false
			
			
			
			get_tile_at_mouse_pos()
			# finds if a building is placed in the tile that is clicked
			for node in get_parent().get_node("Placed-Buildings").get_children():
				for placed_object in node.get_children():
					
					# this line makes it so when you click anywhere not in a menu, it makes every "selected" part in the object = to false
					#placed_object.selected = false
					#print(placed_object.tiles_occupied_by_self)
					if Input.is_action_just_pressed("click") and clicked_cell in placed_object.tiles_occupied_by_self:
					#if placed_object.entered and Input.is_action_just_pressed("click"):#placed_object.global_position.x-placed_object.size.x >= tile_center_pos.x and tile_center_pos.x <= placed_object.global_position.x+placed_object.size.x:#tile_center_pos > map_to_world(world_to_map(placed_object.global_position-placed_object.size)) and tile_center_pos < map_to_world(world_to_map(placed_object.global_position+placed_object.size)) : #world_to_map(placed_object.global_position - placed_object.size) <= world_to_map(tile_center_pos)  or world_to_map(tile_center_pos) >= world_to_map(placed_object.global_position+placed_object.size)  : #world_to_map(placed_object.global_position) == clicked_cell or #placed_object.global_position == self.tile_center_pos:
						
						# when a placed object in Placed-Buildings is clicked, it will update World scene to draw the radius and show gui
						placed_object.selected = !placed_object.selected
						
						
						building_code_background._change_first_var(placed_object.first_changeable_var)
						first_change_var_input.text = str(placed_object.var_dict[0])#placed_object.production_speed)

						# use placed_object.get_name() to have cool @Coal_Factor@1042 but normal is placed_object.building_name
						building_code_background._change_class(placed_object.get_name())
						building_code_background.building = placed_object
						
						if placed_object.selected:
							building_code_background._start_tween_to_open()
						elif not placed_object.selected:
							building_code_background._start_tween_to_close()
						
						
						# parent gets updated to draw the circle radius around building
						get_parent().update()
						
						# deselects all other buildings than the one that is clicked
						for node2 in get_parent().get_node("Placed-Buildings").get_children():
							for placed_object2 in node2.get_children():
								if placed_object2 != placed_object:
									placed_object2.selected = false
							
						return
			
			
			if not "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)) and not stop:
				if factory_selector.selected_button_index != -1:
					_spawn_building()
				
			

func _spawn_building():
	if factory_selector.selected_button_index == -1 or self.clicked_cell == null:
		return
	
	
	var f = factory_selector._get_building_type()
	f = f.instance()
	f.global_position = self.tile_center_pos
	
	
	
	if(factory_selector.building_dict[factory_selector.selected_button_index] == "Factory"):
		self.get_parent().get_node("Placed-Buildings/Factories").add_child(f)
		
	elif(factory_selector.building_dict[factory_selector.selected_button_index] == "Collector"):
		self.get_parent().get_node("Placed-Buildings/Auto-Collectors").add_child(f)
		
		
	elif (factory_selector.building_dict[factory_selector.selected_button_index] == "Storage"):
		self.get_parent().get_node("Placed-Buildings/Factories").add_child(f)
		
		
	elif (factory_selector.building_dict[factory_selector.selected_button_index] == "Conveyor"):
		self.get_parent().get_node("Placed-Buildings/Conveyors").add_child(f)
		
	elif (factory_selector.building_dict[factory_selector.selected_button_index] == "Hub"):
		self.get_parent().get_node("Placed-Buildings/Factories").add_child(f)

	_fill_building_tile_array(f)


# fills array with the tiles that the building occupies
func _fill_building_tile_array(building):
	#var tile_pos = Vector2(10,10)
	for r in range(0,building.tile_rows):
		for c in range(0,building.tile_cols):
			building.tiles_placed_on_x.append(world_to_map(tile_center_pos).x-int(building.tile_cols/2) + r)
			building.tiles_placed_on_y.append(world_to_map(tile_center_pos).y-int(building.tile_rows/2) + c)
			#building.tiles_placed_on.append(Vector2(world_to_map(tile_center_pos).x-int(building.tile_cols/2) + r, world_to_map(tile_center_pos).y-int(building.tile_rows/2) + c))

func _fill_temp_tile_array(vector2) -> Array: 
	var temp_array_x = []
	var temp_array_y = []
	
	for r in range(0,vector2.x):
		for c in range(0,vector2.y):
			temp_array_x.append(world_to_map(tile_center_pos).x-int(vector2.x/2) + r)
			temp_array_y.append(world_to_map(tile_center_pos).y-int(vector2.y/2) + c)
			#temp_array.append(Vector2(world_to_map(tile_center_pos).x-int(vector2.x/2) + r, world_to_map(tile_center_pos).y-int(vector2.y/2) + c))
	return [temp_array_x, temp_array_y]


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
	
	if factory_selector.selected_button_index != -1:
		var f = factory_selector._get_building_type().instance()
		f.global_position = self.tile_center_pos
		f.modulate = Color(0.552941, 0.552941, 0.552941, 0.290196)
		for node in get_parent().get_node("Placed-Buildings").get_children():
			#for num in range(0,2):
			#var node = get_parent().get_node("Placed-Buildings").get_child(num)
			for placed_object in node.get_children():
				if placed_object.global_position == self.tile_center_pos:
					#return
					f.modulate = Color(1, 0.203922, 0.203922, 0.454902)
		if "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)):
			f.modulate = Color(1, 0.203922, 0.203922, 0.454902)
		if temp_building_red:
			f.modulate = Color(1, 0.203922, 0.203922, 0.454902)
		temp_buildings.add_child(f)
		f.z_index = 2
	#elif collector_selector.selected_button_index != -1:
	#	var f = collector_selector._get_collector_type().instance()
	#	f.global_position = self.tile_center_pos
	#	f.modulate = Color(0.552941, 0.552941, 0.552941, 0.290196)
	#	if "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(clicked_cell)):
	#		f.modulate = Color(1, 0.427451, 0.427451, 0.482353)
	#	temp_buildings.add_child(f)

# checks the placement of the temp building, and turns it red if it is over another building or over water
func check_building_placement():
	stop = false
	temp_building_red = false
	if factory_selector.selected_button_index != -1:
		
		# gets the tile positions of the tiles the temp-building will occupy
		var temp_arrays = _fill_temp_tile_array(tile_size_dict[factory_selector.building_dict[factory_selector.selected_button_index]]) 
		for node in get_parent().get_node("Placed-Buildings").get_children():
			if node.name != "Pre-Placement":
				for building in node.get_children():
					for i in range(0,building.tiles_placed_on_x.size()):
						if clicked_cell == Vector2(building.tiles_placed_on_x[i],building.tiles_placed_on_y[i]):
							stop = true
							temp_building_red = true
						
						for c in range(0,temp_arrays[0].size()):
							if Vector2(temp_arrays[0][c],temp_arrays[1][c]) == Vector2(building.tiles_placed_on_x[i],building.tiles_placed_on_y[i]) or "water" in chunk_tile_map.tile_set.tile_get_name(chunk_tile_map.get_cellv(Vector2(temp_arrays[0][c],temp_arrays[1][c]))):
								stop = true
								temp_building_red = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in temp_buildings.get_children():
		child.queue_free()
		#temp_buildings.remove_child(child)
	spawn_temp_building()
	check_building_placement()
	
