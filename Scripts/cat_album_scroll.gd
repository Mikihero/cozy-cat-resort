extends HBoxContainer

@onready var preview_slot = $CurrentlySelected
@onready var list_container = $ScrollContainer/HBoxContainer

func _ready() -> void:
	await get_tree().process_frame 
	
	if list_container.get_child_count() > 0:
		var first_card = list_container.get_child(0)
		preview_slot.character_name = first_card.character_name
		preview_slot.character_image = first_card.character_image
		preview_slot._ready()
		
	setup_buttons()
	update_ui()
	
func setup_buttons():
	var list_cards = list_container.get_children()
	
	for card in list_cards:
		var btn = card.select_btn
		if not btn.pressed.is_connected(_on_character_selected):
			btn.pressed.connect(_on_character_selected.bind(card))
			
func _on_character_selected(clicked_card):
	preview_slot.character_name = clicked_card.character_name
	preview_slot.character_image = clicked_card.character_image
	preview_slot._ready()
	
	update_ui()
	
func update_ui():
	preview_slot.set_selected_mode(true)
	
	var current_name = preview_slot.character_name

	for card in list_container.get_children():
		var is_active = (current_name != "" and card.character_name == current_name)
		
		if is_active:
			card.select_btn.disabled = true
			card.select_btn.text = "Selected"
			card.modulate = Color(0.5, 0.5, 0.5) 
		else:
			card.select_btn.disabled = false
			card.select_btn.text = "Select"
			card.modulate = Color(1, 1, 1)
