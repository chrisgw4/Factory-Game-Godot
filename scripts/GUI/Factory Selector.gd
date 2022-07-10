extends GridContainer


var selected_button_index = -1
var dict:Dictionary = {0:"res://scenes/factory/coal_factory/Coal_Factory.tscn"}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	var index = 0
	for child in self.get_children():
		if child.pressed:
			print('cheese' + str(index))
			selected_button_index = index
		index+=1

func _get_factory_type():
	if selected_button_index != -1:
		return load(dict[selected_button_index])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
