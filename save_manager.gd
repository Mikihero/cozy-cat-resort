extends Node

var save_thread: Thread;
var map:Map; # ref for simpler access

func initialize_save(mapArg:Map):
	self.map = mapArg;
	load_save()
	save_thread = Thread.new();
	save_thread.start(
		func():
			while true:
				await get_tree().create_timer(60).timeout;
				SaveManager.save_entities_to_file();
	)
func load_save():
	if !FileAccess.file_exists("user://save.json"):
		SaveManager.save_entities_to_file();
	var save_file = FileAccess.open("user://save.json", FileAccess.READ);
	var data = JSON.parse_string(save_file.get_line());
	print(data.get("entities") as Array)
	for entDict in (data.get("entities") as Array):
		var entity: MapEntity = MapEntity.deserialize(entDict);
		map.add_entity(entity);
		
func save_entities_to_file():
	var save_file = FileAccess.open("user://save.json", FileAccess.WRITE);
	var data = {
		"entities": []
	};
	for entity in map.get_entities():
		data.entities.append(entity.serialize())
	var data_string = JSON.stringify(data);
	save_file.store_string(data_string);
	print("autosave ", data.entities.size(), " entities")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_APPLICATION_PAUSED:
		SaveManager.save_entities_to_file();
		get_tree().quit()
