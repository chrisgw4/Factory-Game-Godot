class_name SaveGame
extends Resource

const SAVE_PATH = "user://saves/save"

export var version = 1.0

export var camera_pos := Vector2.ZERO

export var player_stats: Resource

#export(NoiseTexture) var chunk_tile_map
#export(int) var chunk_tile_map_seed


func write_savegame():
	ResourceSaver.save(get_save_path(), self)

static func save_exists():
	return ResourceLoader.exists(get_save_path()) 
	


static func load_savegame():
	var save_path := get_save_path()
	if not ResourceLoader.has_cached(save_path):
		return ResourceLoader.load(save_path, "", true)
		
	var file := File.new()
	if file.open(save_path, File.READ) != OK:
		printerr("Couldn't read file " + save_path)
		return null

	var data := file.get_as_text()
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the save game to that temporary file path.
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_string(data)
	file.close()

	# We load the temporary file as a resource.
	var save = ResourceLoader.load(save_path, "", true)
	# And make it take over the save path for the next time the player
	# saves.
	save.take_over_path(tmp_file_path)

	# We delete the temporary file.
	var directory := Directory.new()
	directory.remove(tmp_file_path)
	return save


static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"


# This function allows us to save and load a text resource in debug builds and a
# binary resource in the released product.
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_PATH + extension
