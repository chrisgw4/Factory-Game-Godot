extends TileMap

#onready var tilemap := $TileMap
export var width := 1024#abs(get_parent().get_node("Camera2D").limit_left) + get_parent().get_node("Camera2D").limit_right
export var height := 1024
export var in_seed := ""
var osn := OpenSimplexNoise.new()



func _ready() -> void:
	randomize()
	if in_seed:
		osn.seed = hash(in_seed)
		print(hash(in_seed))
	else:
		osn.seed = randi()
	generate_map()

func generate_map() -> void:
	for x in width:
		for y in height:
			var rand := floor((abs(osn.get_noise_2d(x,y)))*4)
			self.set_cell(x,y, rand)
	pass


func _on_period_slider_value_changed(value: float) -> void:
	osn.period = value
	generate_map()


func _on_octave_slider_value_changed(value: float) -> void:
	osn.octaves = value
	generate_map()


func _on_persist_slider_value_changed(value: float) -> void:
	osn.persistence = value
	generate_map()


func _on_lacun_slider_value_changed(value: float) -> void:
	osn.lacunarity = value
	generate_map()
