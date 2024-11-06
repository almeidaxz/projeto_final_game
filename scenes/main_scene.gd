extends CanvasLayer

@onready var main_scene = get_node(".")
@onready var card_scene = preload("res://scenes/card_back_scene/card_back_scene.tscn")
@onready var background_scene = main_scene.get_child(0)

var cards = {}
var opened_cards = []
var right_pair = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://assets/stack_icons/")
	var file_names = []
	for file_name in dir.get_files():
		if "import" in file_name:
			continue
		if len(file_names) == 6:
			break
		file_names.append(file_name)
	spawn_sprites(file_names)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_card_existance(file_names, cards_list, current_card_name, current_card_index1, current_card_index2) -> Array:
	var new_card_name = ''
	var new_index1 = 0
	var new_index2 = 0
	if current_card_name in cards_list:
		while current_card_name in cards_list:
			new_card_name = file_names[RandomNumberGenerator.new().randi_range(0, len(file_names) - 1)]
			if new_card_name not in cards_list:
				cards_list.append(new_card_name)
				break
	else: cards_list.append(current_card_name)
	if current_card_index1 in cards_list:
		while current_card_index1 in cards_list:
			new_index1 = RandomNumberGenerator.new().randi_range(1, 12)
			if new_index1 not in cards_list:
				cards_list.append(new_index1)
				break
	else: cards_list.append(current_card_index1)
	if current_card_index2 in cards_list:
		while current_card_index2 in cards_list:
			new_index2 = RandomNumberGenerator.new().randi_range(1, 12)
			if new_index2 not in cards_list:
				cards_list.append(new_index2)
				break
	else: cards_list.append(current_card_index2)
				
	return [
		{new_index1 if new_index1 else current_card_index1: new_card_name if new_card_name else current_card_name},
		{new_index2 if new_index2 else current_card_index2: new_card_name if new_card_name else current_card_name}
	]
	
func spawn_sprites(file_names) -> void:
	var cards_list = []
	var already_used = []
	
	for n in range(6):
		var card_name = file_names[RandomNumberGenerator.new().randi_range(0, len(file_names) - 1)]
		var card_index1 = RandomNumberGenerator.new().randi_range(1, 12)
		var card_index2 = RandomNumberGenerator.new().randi_range(1, 12)
		var card_pair_array = check_card_existance(file_names, already_used, card_name, card_index1, card_index2)
		cards_list += card_pair_array

	cards_list.sort_custom(func(a, b): return a.keys() < b.keys())
	
	var first_card_position = Vector2(55, 65)
	for card_pair in cards_list:
		var card = card_scene.instantiate()
		card._set_values(card_pair.keys()[0], card_pair[card_pair.keys()[0]])
		card.scale = Vector2(0.085, 0.085)
		
		var last_child = main_scene.get_child(main_scene.get_child_count() - 1)
		if card_pair.keys()[0] > 6:
			card.position.y = first_card_position.y + 300
			card.position.x = first_card_position.x if card_pair.keys()[0] == 7 else last_child.position.x + 180
		else: 
			card.position.y = first_card_position.y if card_pair.keys()[0] == 1 else last_child.position.y
			card.position.x = first_card_position.x if card_pair.keys()[0] == 1 else last_child.position.x + 180
			
		card.texture_normal = load("res://assets/card_assets/card_back/card_back.png")
		card.connect("_pressed", _on_card_back_scene_pressed)
		main_scene.add_child(card)
		cards[card_pair.keys()[0]] = card
		
func _on_card_back_scene_pressed(event) -> void:
	if len(opened_cards) >= 2 or $Timer2.time_left > 0:
		return

	var card_info = event.split(", ")
	cards[int(card_info[0])].scale = Vector2(0.087, 0.087)
	cards[int(card_info[0])].texture_normal = load("res://assets/card_assets/cards_front/card_{card_name}".format({"card_name": card_info[1]}))
	opened_cards.append(card_info)
	if len(opened_cards) == 2:
		$Timer.start()
		if opened_cards[0][1] == opened_cards[1][1] and opened_cards[0][0] != opened_cards[1][0]:
			right_pair = true
		else:
			right_pair = false

func _on_timer_timeout() -> void:
	$Timer.stop()
	if right_pair:
		handle_remove_child()
	else:
		handle_reset_cards()
	$Timer2.start()
	
func handle_remove_child() -> void:
	for opened_card in opened_cards:
		var card = cards[int(opened_card[0])]
		main_scene.remove_child(card);
		cards.erase(int(opened_card[0]))
		opened_cards = []
	if !len(cards):
		var image = background_scene.get_children()[0]
		image.texture = load("res://assets/backgrounds/background_win.png")
		
func handle_reset_cards() -> void:
	for opened_card in opened_cards:
		cards[int(opened_card[0])].texture_normal = load("res://assets/card_assets/card_back/card_back.png")
		cards[int(opened_card[0])].scale = Vector2(0.085, 0.085)
		opened_cards = []


func _on_timer_2_timeout() -> void:
	$Timer2.stop()
