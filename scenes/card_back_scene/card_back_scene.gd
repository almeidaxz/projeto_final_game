extends TouchScreenButton

var card_index = 0
var card_stack = ''

signal _pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _set_values(index, stack):
	card_index = index
	card_stack = stack

func _on_pressed(event) -> void:
	emit_signal("_pressed", "{card_index}, {card_stack}".format({"card_index": card_index, "card_stack": card_stack}))
