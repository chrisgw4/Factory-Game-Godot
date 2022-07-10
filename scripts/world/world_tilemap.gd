extends TileMap

var clicked_cell = null
var tile_center_pos = null

onready var factory_selector = get_parent().get_node("CanvasLayer/Factory Selector")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			self.clicked_cell = world_to_map(event.position)
			self.tile_center_pos = map_to_world(self.clicked_cell) + cell_size / 2
			
			for factory in get_parent().get_node("Factories").get_children():
				if factory.global_position == self.tile_center_pos:
					print("fail")
					return
			
			_spawn_factory()
			

func _spawn_factory():
	if(self.clicked_cell != null and get_parent().get_node("CanvasLayer/Factory Selector").selected_button_index != -1):
		#self.get_cell(tile_map.clicked_cell.x, tile_map.clicked_cell.y)
		var f = factory_selector._get_factory_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Factories").add_child(f)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
