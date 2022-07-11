extends "res://scripts/factory/Factory.gd"





# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	self.produced_resource = "coal"
	self.production_speed = 10
	
	# costs 10 coal to purchase coal factory
	self.price = 10
	self.payment = "Coal"

func spawn_resource():
	if self.produced_resource == null:
		return
	self.RNG.randomize()
	
	var coal = load("res://scenes/resource/Coal.tscn")
	var resource = coal.instance()
	
	var tween:Tween = resource.get_node("Tween")
	
	while resource.go_position == Vector2(0,0) or self.global_position.distance_to(resource.go_position) > 40:
		resource.go_position.x = self.global_position.x+RNG.randi_range(-40,40)
		resource.go_position.y = self.global_position.y+RNG.randi_range(-40,40)
	
	resource.global_position = self.global_position
	
	#tween.interpolate_property(resource, "position",
	#	self.global_position, resource.go_position, .05,
	#	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()
	
	
	self.get_parent().get_parent().get_parent().get_node("Resources").add_child(resource)
	
	resource.tween.interpolate_property(resource, "position",
		self.global_position, resource.go_position, .15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
