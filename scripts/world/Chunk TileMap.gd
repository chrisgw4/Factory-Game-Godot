extends TileMap


export(int) var chunk_width = 8
export(int) var chunk_height = 8
var heightMapTexture = NoiseTexture.new()

var noise_seed = 0


onready var player = get_parent().get_node("Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var x = RandomNumberGenerator.new()
	x.randomize()
	noise_seed = randi()
	heightMapTexture.width = 512
	heightMapTexture.height = 512
	if heightMapTexture.noise == null:
		print('PPPPP')
		heightMapTexture.noise = OpenSimplexNoise.new()
		heightMapTexture.noise.seed = noise_seed
		print("Seed: " + str(heightMapTexture.noise.seed))
	
	#generateGridChunk(player.position)
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
			var weight:float = (noise_value+1.0)/2
			var height:float = floor(lerp(0,8,weight))*1
			
			for mz in range(0,height):
				set_cellv(Vector2(mx,my),floor(mz/2))
			


func _on_MapUpdateTimer_timeout():
	generateGridChunk(player.position)
	if noise_seed != heightMapTexture.noise.seed:
		heightMapTexture.noise.seed = noise_seed


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"noise_seed" : noise_seed,
		"chunk_width" : chunk_width,
		"chunk_height" : chunk_height,
		
	}
	return save_dict





