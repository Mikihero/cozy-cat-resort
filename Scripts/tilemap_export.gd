extends TileMapLayer

func _ready():
	export_to_png("res://Assets/entities/rock/small.png")

func export_to_png(path: String):
	var rect = get_used_rect()
	if rect.size == Vector2i.ZERO: return

	var tile_size = tile_set.tile_size
	var full_image = Image.create(rect.size.x * tile_size.x, rect.size.y * tile_size.y, false, Image.FORMAT_RGBA8)
	var source: TileSetAtlasSource = tile_set.get_source(get_tile_set().get_source_id(0))
	var atlas_image = source.texture.get_image()

	for coords in get_used_cells():
		var atlas_coords = get_cell_atlas_coords(coords)
		var alt_id = get_cell_alternative_tile(coords)
		var tile_rect = source.get_tile_texture_region(atlas_coords)

		# Wycinamy pojedynczy kafelek z atlasu
		var tile_image = atlas_image.get_region(tile_rect)

		# Obsługa transformacji (Obrót i Flip)
		# W Godot 4 TileMapLayer przechowuje to w Alternative Tile ID
		if alt_id != 0:
			if alt_id & TileSetAtlasSource.TRANSFORM_FLIP_H:
				tile_image.flip_x()
			if alt_id & TileSetAtlasSource.TRANSFORM_FLIP_V:
				tile_image.flip_y()
			if alt_id & TileSetAtlasSource.TRANSFORM_TRANSPOSE:
				# Transpozycja + Flip to w praktyce rotacja o 90 stopni
				tile_image.rotate_90(CLOCKWISE)
				# Przy transpozycji często potrzebny jest dodatkowy flip,
				# zależnie od tego jak Godot mapuje dany obrót
				tile_image.flip_x()

		var dest_pos = (coords - rect.position) * tile_size
		full_image.blit_rect(tile_image, Rect2i(Vector2i.ZERO, tile_size), dest_pos)


	full_image.save_png(path)
	print("Eksport zakończony: ", path)
