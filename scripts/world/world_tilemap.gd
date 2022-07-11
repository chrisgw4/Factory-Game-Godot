extends TileMap

var clicked_cell = null
var tile_center_pos = null

onready var factory_selector = get_parent().get_node("CanvasLayer/ScrollContainer/Factory Selector")
onready var collector_selector = self.get_parent().get_node("CanvasLayer/Collector Selector")

onready var camera = get_parent().get_node("Camera2D")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			# event.position works with the scaling of the window
			self.clicked_cell = world_to_map(event.position+camera.global_position)
			self.tile_center_pos = map_to_world(self.clicked_cell) + cell_size / 2
			
			for node in get_parent().get_node("Placed-Buildings").get_children():
				for placed_object in node.get_children():
			#for factory in get_parent().get_node("Placed-Buildings/Factories").get_children():
					if placed_object.global_position == self.tile_center_pos:
						print("fail")
						return
			#print(self.tile_center_pos)
			#print(event.global_position)
			#print(str(collector_selector.selected_button_index) + " COLLECTOR")
			#print(str(factory_selector.selected_button_index) + " FACTORY")
			if factory_selector.selected_button_index != -1:
				_spawn_factory()
			elif collector_selector.selected_button_index != -1:
				_spawn_collector()
			

func _spawn_factory():
	if(self.clicked_cell != null and get_parent().get_node("CanvasLayer/ScrollContainer/Factory Selector").selected_button_index != -1):
		#self.get_cell(tile_map.clicked_cell.x, tile_map.clicked_cell.y)
		var f = factory_selector._get_factory_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Factories").add_child(f)

func _spawn_collector():
	if(self.clicked_cell != null and collector_selector.selected_button_index != -1):
		#self.get_cell(tile_map.clicked_cell.x, tile_map.clicked_cell.y)
		print("D")
		var f = collector_selector._get_collector_type().instance()
		f.global_position = self.tile_center_pos
		self.get_parent().get_node("Placed-Buildings/Auto-Collectors").add_child(f)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
