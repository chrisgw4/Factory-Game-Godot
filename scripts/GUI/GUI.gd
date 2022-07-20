extends CanvasLayer

onready var factory_selector_handler = get_node("OpenCloseFactorySelector")
onready var factory_selector = get_node("BuildingSelectorBackground/ScrollContainer/Factory Selector")
onready var scroll_factory_button = get_node("BuildingSelectorBackground/ScrollContainer")
onready var base_position_scroll_factory = scroll_factory_button.rect_global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if factory_selector_handler.pressed:
				var tween = factory_selector.get_node("Tween")
				var tween2 = factory_selector_handler.get_node("Tween")
				if not factory_selector.closed:
					tween.interpolate_property(scroll_factory_button, "rect_position", base_position_scroll_factory,  base_position_scroll_factory+Vector2(130,0), .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.interpolate_property(factory_selector_handler, "rect_position", factory_selector_handler.open_position, factory_selector_handler.closed_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)					
					factory_selector.closed = true
				elif factory_selector.closed:
					tween.interpolate_property(scroll_factory_button, "rect_position", base_position_scroll_factory+Vector2(130,0), base_position_scroll_factory, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)										
					#tween.interpolate_property(factory_selector, "rect_position", factory_selector.closed_position, factory_selector.open_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)					
					tween.interpolate_property(factory_selector_handler, "rect_position", factory_selector_handler.closed_position, factory_selector_handler.open_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)										
					factory_selector.closed = false
				tween.start()
				#print("ddd")
				#factory_selector.visible = not factory_selector.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
