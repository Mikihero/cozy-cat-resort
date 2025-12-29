extends ScrollContainer

func _gui_input(event):
	if event is InputEventScreenDrag:
		accept_event()
