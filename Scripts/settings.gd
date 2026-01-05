extends Control

var active_audio_bus: String = "";
@onready var music_slider = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer/MusicSlider;
@onready var sound_slider = $MarginContainer/ScrollContainer/VBoxContainer/GridContainer/SoundSlider;
@onready var close_button = $exampleCancelIconButton;
@onready var save_button = $MarginContainer/ScrollContainer/VBoxContainer/SaveButton;
var map: Map;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = get_node("/roon/Main/Map");
	music_slider.drag_started.connect(func(): active_audio_bus = "Music")
	music_slider.drag_ended.connect(func(_c): active_audio_bus = "")

	sound_slider.drag_started.connect(func(): active_audio_bus = "Sound")
	sound_slider.drag_ended.connect(func(_c): active_audio_bus = "")
	
	close_button.pressed.connect(func(): self.visible = false);
	save_button.pressed.connect(func(): map.save_to_file());
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if active_audio_bus != "":
			var value: float;
			match active_audio_bus:
				"Sound":
					value = sound_slider.ratio
				"Music":
					value = music_slider.ratio
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(active_audio_bus), value)
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
