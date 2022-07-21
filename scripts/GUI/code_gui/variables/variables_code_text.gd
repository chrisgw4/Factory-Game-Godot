extends RichTextLabel


signal text_entered

var input_text = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VariableInput_text_entered(new_text):
	input_text = new_text
	emit_signal("text_entered")
	
	
