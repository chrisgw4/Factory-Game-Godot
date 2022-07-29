extends TextureRect


var building = null

var base_position = get_rect().position
var close_base_position = base_position+Vector2(0,550)
var ready_to_open = base_position-Vector2(0,550)
onready var tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	_start_tween_to_close()
	visible = false
	#_start_tween_to_open()
	#get_node("Variable").bbcode_text = "var "
	#get_node("Variable").append_bbcode("[color=#adafb6]production_speed =[/color]")
	#print(get_node("Variable").text)

func _process(delta:float):
	if get_rect().position == close_base_position and visible:
		self.visible = false
		get_rect().position = ready_to_open
	#if get_rect().position != base_position and not self.visible and Input.is_action_just_pressed("open_building_menu"):
	#	_start_tween_to_open()
	#	self.visible = true
	elif get_rect().position == base_position and self.visible and Input.is_action_just_pressed("open_building_menu"):
		_start_tween_to_close()
		get_parent().get_parent().unselect_all()
		#tween.interpolate_property(self, "rect_position", ready_to_open,  base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#tween.start()
		self.visible = true


# changes the first variable's name on the code background
func _change_first_var(new_var_name):
	#get_node("FirstVar/FirstVarToChange2").text = new_var_name + " ="
	get_node("VBoxContainer/Variable").bbcode_text = "[color={code/name}]var [/color][color=#adafb6]" + str(new_var_name) + " =[/color]"

# changes the name of the class on the code background
func _change_class(new_class_name):
	get_node("VBoxContainer/Class").bbcode_text = "[color=#ff7084]Class:[/color] [color=#1fc348]"+new_class_name+"[/color]"

func _change_first_var_desc(new_var_desc):
	pass
	#new_var_desc = "# " + new_var_desc
	#get_node("FirstVarDescription").text = new_var_desc


# called when the first variable's text box recieves a new text and changes the variable of the building to reflect the change
func _on_FirstVarChangeInput_text_entered(new_text):
	if building != null and new_text.is_valid_float():
		building.set(building.change_var_dict["firstvar"], new_text)
		

func _start_tween_to_close():
	tween.interpolate_property(self, "rect_position", base_position,  close_base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _start_tween_to_open():
	if get_rect().position != base_position and not self.visible:
		tween.interpolate_property(self, "rect_position", ready_to_open,  base_position, .15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		self.visible = true
		_type_letters()

func _type_letters():
	for node in get_child(0).get_children():
		if node.name != "Tween":
			if node.get_child_count()>0:
				for node2 in node.get_children():
					if node2.name != "FirstVarChangeInput" and node2.get_class() == "RichTextLabel":
						tween.interpolate_property(node2, "visible_characters", 0, len(node2.text), 1.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					if node2.name == "VariableInput":
						tween.interpolate_property(node2, "visible", false, true, 1.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						
			tween.interpolate_property(node, "visible_characters", 0, len(node.text), .9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)


func _on_Variable_text_entered():
	print($VBoxContainer/Variable.input_text)
	if building != null and $VBoxContainer/Variable.input_text.is_valid_float():
		building.set(building.change_var_dict["firstvar"], $VBoxContainer/Variable.input_text)
