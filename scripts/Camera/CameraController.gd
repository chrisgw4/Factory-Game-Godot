extends Camera2D

var zoom_min:Vector2 = Vector2(0.2,0.2)
var zoom_max:Vector2 = Vector2(2.0,2.0)
var zoom_speed:Vector2 = Vector2(0.2,0.2)


var zoom_step = 1.1

func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_at_point(zoom_step,mouse_position)
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_at_point(1/zoom_step,mouse_position)

func zoom_at_point(zoom_change, point):
	var c0 = global_position # camera position
	
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var screen_height = ProjectSettings.get_setting("display/window/size/height")
	
	var v0 = Vector2(get_viewport().size.x*(screen_width/get_viewport().size.x), get_viewport().size.y*(screen_height/get_viewport().size.y))# viewport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = z0 * zoom_change # next zoom value

	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	if z1 > zoom_min and z1 < zoom_max:
		zoom = z1
		global_position = c1


#func _inputs(event):
#	if event is InputEventMouseButton:
#		if event.is_pressed():
#			if event.button_index == BUTTON_WHEEL_UP:
#				if zoom > zoom_min:
#					zoom -= zoom_speed
#			if event.button_index == BUTTON_WHEEL_DOWN:
#				if zoom < zoom_max:
#					zoom += zoom_speed


func move_camera(delta:float):
	#var nextPos = Vector2(0,0)
	#if camera.position.x <= camera.limit_right and camera.position.x >= camera.limit_left and camera.position.y >= camera.limit_top and camera.position.y <= camera.limit_bottom:
	if Input.is_action_pressed("move_right"):
		position.x += 200*delta
	if Input.is_action_pressed("move_left"):
		position.x -= 200*delta
	if Input.is_action_pressed("move_down"):
		position.y += 200*delta
	if Input.is_action_pressed("move_up"):
		position.y -= 200*delta
	#print(str(camera.position.y+camera.get_viewport().size.y) + " " + str(camera.limit_bottom))
	
	# clamps camera no matter the size, and works flawlessly to prevent camera from going out of bounds
	var left = limit_left + (offset.x*zoom.x) + get_viewport_rect().size.x/2*zoom.x
	var right = limit_right - (offset.x*zoom.x) - get_viewport_rect().size.x/2*zoom.x
	var top = limit_top + (offset.y*zoom.y) + get_viewport_rect().size.y/2*zoom.x
	var bottom = limit_bottom - (offset.y*zoom.y) - get_viewport_rect().size.y/2*zoom.x
	
	self.position.x = clamp(self.position.x, left, right)
	self.position.y = clamp(self.position.y, top, bottom)
	
	
	
	# keeps the camera from getting offset dramatically when at the world borders
	#if camera.position.y+camera.get_viewport().size.y >= camera.limit_bottom:
	#	camera.position.y = camera.limit_bottom-camera.get_viewport().size.y
	#if camera.position.y <= camera.limit_top:
	#	camera.position.y = camera.limit_top
	#print(camera.get_viewport().size.x)
	#if camera.position.x+camera.get_viewport().size.x >= camera.limit_right:
		#camera.position.x = camera.limit_right-camera.get_viewport().size.x
		#print(camera.position.x)
		
	#if camera.position.x <= camera.limit_left:
	#	camera.position.x = camera.limit_left
		


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
