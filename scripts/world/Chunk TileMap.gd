extends TileMap


export(int) var chunk_width = 8
export(int) var chunk_height = 8
var heightMapTexture = NoiseTexture.new()

var noise_seed = 0

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
	for i in range(0,100):
		x.randomize()
	noise_seed = x.randi()
	heightMapTexture.width = 2048
	heightMapTexture.height = 2048
	
	load_chunk_map()
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



func _generate_ores():
	var chunk_start_x = -8196#0-chunk_width
	var chunk_start_y = 0-chunk_width
	var chunk_stop_x = 0+chunk_width/2
	var chunk_stop_y = 0+chunk_width/2
	var chances = 4
	var rng = RandomNumberGenerator.new()
	var ore_size = rng.randi_range(0,4)
	
	var num_chunks = (512*512)/32
	for i in range(0,1):
		# there are 8 chunks on each X axis row so 8192/1024 = 8
		for x_block in range(0,num_chunks/chunk_width):
			for y_block in range(0,num_chunks/chunk_height):
				for p in range(0,chances):
					var pos = Vector2(chunk_start_x+x_block*32, chunk_start_y+y_block*32)
					
					pos = map_to_world(world_to_map(pos))+cell_size/2
					var temp = load("res://scenes/ores/Iron.tscn").instance()
					temp.position = pos
					self.add_child(temp)
					temp.z_index = 10
					print(pos)




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



