extends TileMap


export(int) var chunk_width = 8
export(int) var chunk_height = 8
var heightMapTexture = NoiseTexture.new()

var noise_seed = 122

var img :Image = Image.new()



onready var player = get_parent().get_node("Camera2D")

var ore_map

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	#randomize()
	#randomize()
	
	#img.load("res://sprites/tilemap/sqaure_gradient.png")
	#img.resize(16384,16384)
	#img.lock()
	
	var x = RandomNumberGenerator.new()
	x.seed = noise_seed
	#for i in range(0,100):
	#	x.randomize()
	noise_seed = x.randi()
	heightMapTexture.width = 2048
	heightMapTexture.height = 2048
	
	load_chunk_map()
	get_node("Ores").load_ores()
	if heightMapTexture.noise == null:
		
		heightMapTexture.noise = OpenSimplexNoise.new()
		heightMapTexture.noise.octaves = 9
		# persistence 10 makes it look like circuit board
		heightMapTexture.noise.persistence = .7
		heightMapTexture.noise.seed = noise_seed
		heightMapTexture.bump_strength = 1
		heightMapTexture.as_normalmap = true
		
		print("Seed: " + str(heightMapTexture.noise.seed))
	
	generateGridChunk(Vector2(0,0))
	if get_node("Ores").get_child_count() == 0:
		_generate_ores()
	#setGridChunk(0,chunk_width, 0, chunk_height)
	

func generateGridChunk(playerpos:Vector2) -> void:
	clear()
	var chunk_center = world_to_map(playerpos)
	var row_start: float = chunk_center.x - (chunk_width/2)
	var row_end: float = chunk_center.x + (chunk_width/2)
	var col_start: float = chunk_center.y - (chunk_height/2)
	var col_end: float = chunk_center.y + (chunk_height/2)
	setGridChunk(col_start, col_end, row_start, row_end)
	
	#print(heightMapTexture.noise.seed)
	

func setGridChunk(columnStart, columnEnd, rowStart, rowEnd):
	#if columnStart < 0:
	#	columnStart = 0
	#if rowStart < 0:
	#	rowStart = 0
	
	#if columnEnd >= heightMapTexture.width:
	#	columnEnd = heightMapTexture.width-1
	#if rowEnd >= heightMapTexture.height:
	#	rowEnd = heightMapTexture.height-1
	
	for mx in range(rowStart, rowEnd):
		for my in range(columnStart, columnEnd):
			var noise_value:float = heightMapTexture.noise.get_noise_2d(mx,my)
			#var gradient_value = img.get_pixel(mx,my)
			#print(img.get_pixel(0,0))
			#print(img.get_pixel(img.get_width()/2,img.get_width()/2))
			#var weight = 0
			#if gradient_value[0] > .7:
			#	weight = (noise_value+1.0-gradient_value[0])/1.7#1.7#/1.7
			#else:
			var weight:float = (noise_value+1.0)/1.7#1.7#/1.7		
			
			var height:float = floor(lerp(0,3,weight))*1
			
			
			set_cellv(Vector2(mx,my),floor(height))
			


func _on_MapUpdateTimer_timeout():
	#generateGridChunk(player.position)
	if noise_seed != heightMapTexture.noise.seed:
		heightMapTexture.noise.seed = noise_seed


# spawns ore instances as sprites ontop of the tilemap
func _generate_ores():
	var chunk_start_x = 0-chunk_width*16#-8196#
	var chunk_start_y = 0-chunk_width*16
	var chunk_stop_x = 0+chunk_width*16
	var chunk_stop_y = 0+chunk_width*16
	var chances = 4
	var rng = RandomNumberGenerator.new()
	var ore_size = rng.randi_range(0,4)
	
	rng.seed = noise_seed
	
	
	
	var num_chunks = (512*512)/32
	
	# an ore spawner, spawns ores in veins, but never fully surrounds one 
	for i in range(0,32):
		# there are 8 chunks on each X axis row so 8192/1024 = 8
		for x_block in range(0,num_chunks/chunk_width*i):
			for y_block in range(0,num_chunks/chunk_height*i):
				for p in range(0,1):
					#rng.randomize()
					if rng.randf_range(0,100) < .0015:
						var pos = Vector2(chunk_start_x+x_block*32, chunk_start_y+y_block*32)
						
						pos = map_to_world(world_to_map(pos))+cell_size/2
						var temp = load("res://scenes/ores/Iron.tscn").instance()
						temp.position = pos
						
						if "water" in tile_set.tile_get_name(get_cellv(pos)):
							print("water")
							get_node("Ores").add_child(temp)
						temp.z_index = 10
						#print(pos)
						
						for num in rng.randf_range(0,10):
							var skip = false
							
							# keeps track of the amount of ores surrounding the position
							# if the surround_count is > 7 then there shouldnt be another ore placed in the chunk, cause then one would be unreachable
							var surround_count = 0
							
							#rng.randomize()
							pos = Vector2(chunk_start_x+(x_block+rng.randi_range(0,4))*32, chunk_start_y+(y_block+rng.randi_range(0,4))*32)							
							for ore in get_node("Ores").get_children(): 
								if pos == ore.global_position:
									skip = true
								if pos.distance_to(ore.global_position) <= 32:
									surround_count+=1
									print(surround_count)
							
							if surround_count > 6:
								skip = true
								
							if not skip:
								pos = map_to_world(world_to_map(pos))+cell_size/2
								temp = load("res://scenes/ores/Iron.tscn").instance()
								temp.position = pos
								get_node("Ores").add_child(temp)
								temp.z_index = 10
								#rng.randomize()
								




func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"noise_seed" : noise_seed,
		"chunk_width" : chunk_width,
		"chunk_height" : chunk_height,
	}
	return save_dict


func load_chunk_map():
	
	var save_game = File.new()
	if not save_game.file_exists("user://saves/chunk_map.save"):
		return # Error! We don't have a save to load.



	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://saves/chunk_map.save", File.READ)
   
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		
		if current_line == null:
			continue
		

		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "direction_x" or i == "direction_y":
				continue
			self.set(i, current_line[i])

	save_game.close()



