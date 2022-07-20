extends TextureRect


var base_position = get_rect().position
var close_base_position = base_position+Vector2(0,550)
var ready_to_open = base_position-Vector2(0,550)
onready var tween = get_node("Tween")
onready var close_button = get_node("CloseButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_rect().position == close_base_position and visible:
		self.visible = false
		get_rect().position = ready_to_open
	if get_rect().position != base_position and not self.visible and Input.is_action_just_pressed("open_building_menu"):
		tween.interpolate_property(self, "rect_position", ready_to_open,  base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		self.visible = true
	elif get_rect().position == base_position and self.visible and Input.is_action_just_pressed("open_building_menu"):
		_start_tween_to_close()
		#tween.interpolate_property(self, "rect_position", ready_to_open,  base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#tween.start()
		self.visible = true


func _on_CloseButton_pressed():
	_start_tween_to_close()

func _start_tween_to_close():
	tween.interpolate_property(self, "rect_position", base_position,  close_base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



