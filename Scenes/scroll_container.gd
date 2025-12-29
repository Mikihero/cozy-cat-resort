extends ScrollContainer

@onready var list_container = $HBoxContainer

func _ready():
	setup_buttons()
	update_preview_slot()
	
func setup_buttons():
	var all_cards = list_container.get_children()
	
	for i in range(1, all_cards.size()):
		var card = all_cards[i]
		
		var btn = card.select_btn
		if not btn.pressed.is_connected(_on_character_selected):
			btn.pressed.connect(_on_character_selected.bind(card))
			
func _on_character_selected(clicked_card):
	var preview_slot = list_container.get_child(0)
	
	preview_slot.character_name = clicked_card.character_name
	preview_slot.character_image = clicked_card.character_image
	
	preview_slot._ready() 
	
	update_preview_slot()
	
func update_preview_slot():
	var all_cards = list_container.get_children()
	var preview_slot = all_cards[0]
	
	preview_slot.set_selected_mode(true)
	
	for i in range(1, all_cards.size()):
		var card = all_cards[i]
		var is_currently_active = (card.character_name == preview_slot.character_name)
		
		if is_currently_active:
			card.select_btn.disabled = true
			card.select_btn.text = "Selected"
			card.modulate = Color(0.5, 0.5, 0.5) 
		else:
			card.select_btn.disabled = false
			card.select_btn.text = "Select"
			card.modulate = Color(1, 1, 1)
	
"""
func refresh_album():
	var cards = list_container.get_children()
	
	for i in range(cards.size()):
		var card = cards[i]
		card.set_selected_mode(i == 0)
		
		var btn = card.select_btn
		if not btn.pressed.is_connected(_on_select_pressed):
			btn.pressed.connect(_on_select_pressed.bind(card))

func _on_select_pressed(clicked_card):
	var old_index = clicked_card.get_index()
	list_container.move_child(clicked_card,0)
	refresh_album()
"""
func _gui_input(event):
	if event is InputEventScreenDrag:
		accept_event()
