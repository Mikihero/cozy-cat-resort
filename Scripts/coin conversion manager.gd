extends VBoxContainer

# @onready var quickConvertCheckbox = $"convert setting/quick convert container/quick convert checkbox"
@onready var confirm_scene = preload("res://Scenes/examples/confirm.tscn")
@onready var ok_scene = preload("res://Scenes/examples/ok.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_convert_golden_to_silver_button_pressed() -> void:
	if Globals.GoldCatCoins - 1 < 0:
		var ok_scene_instance = ok_scene.instantiate()
		ok_scene_instance.message_text = "Not enough gold catcoins."
		add_child(ok_scene_instance)
		return
	if $"quick convert setting/quick convert container/quick convert checkbox".button_pressed:	
		do_conversion("golden")
	else:
		var confirm_scene_instance = confirm_scene.instantiate()
		confirm_scene_instance.message_text = "Are you sure you want to convert 1 gold catcoin?"
		confirm_scene_instance.action_to_execute = do_conversion
		confirm_scene_instance.arguments = "golden"
		add_child(confirm_scene_instance)

func _on_convert_diamond_to_golden_button_pressed() -> void:
	if Globals.DiamondCatCoins - 1 < 0:
		var ok_scene_instance = ok_scene.instantiate()
		ok_scene_instance.message_text = "Not enough diamond catcoins."
		add_child(ok_scene_instance)
		return
	if $"quick convert setting/quick convert container/quick convert checkbox".button_pressed:	
		do_conversion("diamond")
	else:
		var confirm_scene_instance = confirm_scene.instantiate()
		confirm_scene_instance.message_text = "Are you sure you want to convert 1 diamond catcoin?"
		confirm_scene_instance.action_to_execute = do_conversion
		confirm_scene_instance.arguments = "diamond"
		add_child(confirm_scene_instance)

func do_conversion(from: String) -> void:
	if from == "golden":
		Globals.GoldCatCoins -= 1
		Globals.CatCoins += 10
	elif from == "diamond":
		Globals.DiamondCatCoins -= 1
		Globals.GoldCatCoins += 10
	else:
		push_error("Conversion on invalid coin type: ", from)
