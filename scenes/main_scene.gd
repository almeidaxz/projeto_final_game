extends CanvasLayer

@onready var main_scene = get_node(".")
@onready var card_scene = preload("res://scenes/card_back_scene/card_back_scene.tscn")
@onready var timer = get_node

var cards = {}
var opened_cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://assets/stack_icons/")
	var file_names = []
	for file_name in dir.get_files():
		if "import" in file_name:
			continue
		if len(file_names) == 5:
			break
		file_names.append(file_name)
	spawn_sprites(file_names)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_sprites(file_names) -> void:
	var first_card_position = Vector2(75, 45)
	var cards_list = []
	
	# criar loop que gera 5 números aleatórios de 0 a 10
	# criar array que guarda os 5 números e nomes dos cards
	# gerar 2 números aleatórios de 0 a 10 para cada um dos 5 cards e por esses números e nomes de card num array
	# iterar sobre o array com 10 itens tendo 2 pra cada
	for n in range(10):
		var rng = RandomNumberGenerator.new().randi_range(0, 9)
		if rng not in cards_list:
			cards_list.append(rng)
		else:
			while rng in cards_list:
				rng = RandomNumberGenerator.new().randi_range(0, 9)
				if rng not in cards_list:
					cards_list.append(rng)
					break
		
		var card = card_scene.instantiate()
		card._set_values(n, file_names[n])
		card.scale = Vector2(0.086, 0.086)
		
		var last_child = main_scene.get_child(main_scene.get_child_count() - 1)
		if n > 4:
			card.position.y = first_card_position.y + 320
			card.position.x = first_card_position.x if n == 5 else last_child.position.x + 215
		else: 
			card.position.y = first_card_position.y if n == 0 else last_child.position.y
			card.position.x = first_card_position.x if n == 0 else last_child.position.x + 215
			
		card.texture_normal = load("res://assets/card_assets/card_back/card_back.png")
		card.connect("_pressed", _on_card_back_scene_pressed)
		main_scene.add_child(card)
		cards[n] = card
		
func _on_card_back_scene_pressed(event) -> void:
	if len(opened_cards) == 2:
		return
	var card_info = event.split(", ")
	cards[int(card_info[0])].texture_normal = load("res://assets/card_assets/cards_front/card_{card_name}".format({"card_name": card_info[1]}))
	opened_cards.append(card_info)
	if len(opened_cards) == 2:
		$Timer.start()
		if opened_cards[0][1] == opened_cards[1][1]:
			for opened_card in opened_cards:
				main_scene.RemoveChild(cards[int(opened_card[0])].GetInstance());
				#cards[int(opened_card[0])]

func _on_timer_timeout() -> void:
	reset_cards()

func reset_cards() -> void:
	for opened_card in opened_cards:
		cards[int(opened_card[0])].texture_normal = load("res://assets/card_assets/card_back/card_back.png")
	opened_cards = []
