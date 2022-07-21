extends Button


export(String) var scene_to_load 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	var dir = Directory.new()
	dir.open("user://saves")
	dir.remove("save.tres")
	dir.remove("chunk_map.save")
	dir.remove("factories.save")
