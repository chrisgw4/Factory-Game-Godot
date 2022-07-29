extends TileMap


export(int) var chunk_width = 512
export(int) var chunk_height = 512



# Called when the node enters the scene tree for the first time.
func _ready():
	
	generateGridChunk(Vector2(0,0))

func generateGridChunk(playerpos:Vector2) -> void:
	#clear()
	var chunk_center = world_to_map(playerpos)
	var row_start: float = chunk_center.x - (chunk_width/2)
	var row_end: float = chunk_center.x + (chunk_width/2)
	var col_start: float = chunk_center.y - (chunk_height/2)
	var col_end: float = chunk_center.y + (chunk_height/2)
	setGridChunk(col_start, col_end, row_start, row_end)
	


func setGridChunk(columnStart, columnEnd, rowStart, rowEnd):
	
	var chunk_start_x = 0-chunk_width/2
	var chunk_start_y = 0-chunk_width/2
	var chunk_stop_x = 0+chunk_width/2
	var chunk_stop_y = 0+chunk_width/2
	var chances = 4
	var rng = RandomNumberGenerator.new()
	var ore_size = rng.randi_range(0,4)
	
	var num_chunks = (512*512)/32
	for i in range(0,num_chunks):
		for p in range(0,chances):
			#var pos = Vector2(chunk_start_x+rng.randi_range(0,8192), chunk_start_y+rng.randi_range(0,8192))
			var temp = load("res://scenes/ores/Iron.tscn").instance()
			temp.position = Vector2(0,0)
			self.add_child(temp)
			
			





func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"chunk_width" : chunk_width,
		"chunk_height" : chunk_height,
	}
	return save_dict

func load_ore_map():
	
	var save_game = File.new()
	if not save_game.file_exists("user://saves/ore_map.save"):
		return # Error! We don't have a save to load.



	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://saves/ore_map.save", File.READ)
   
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		
		if current_line == null:
			continue
		
		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(current_line["filename"]).instance()
		#add_child(new_object)
		#move_child(new_object, 0)
		#print(new_object.get_position())
		#new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		#new_object.direction = Vector2(current_line["direction_x"], current_line["direction_y"])
		
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "direction_x" or i == "direction_y":
				continue
			self.set(i, current_line[i])

	save_game.close()



