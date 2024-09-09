extends Node

const progress_dir = "user://survival-game/"
const progress_path = "user://survival-game/progress.save"

const HEIRLOOM = "heirloom"

var progress = {
	HEIRLOOM: 0
}

func save():
	var err = DirAccess.make_dir_recursive_absolute(progress_dir)
	if err != Error.OK:
		push_warning("Failed to create save dir: ", err)
		return
		
	var save_file = FileAccess.open(progress_path, FileAccess.WRITE)
	if !save_file:
		push_warning("Save file %s failed to open" % progress_path)
		return

	save_file.store_buffer(var_to_bytes(progress))

func load():
	if !FileAccess.file_exists(progress_path):
		push_warning("Save file does not exist")
		return
		
	var save_file = FileAccess.open(progress_path, FileAccess.READ)
	if !save_file:
		push_warning("Save file %s failed to load" % progress_path)
		return
		
	var loaded = bytes_to_var(save_file.get_buffer(save_file.get_length()))
	if !loaded || !loaded is Dictionary:
		push_warning("Unexpected load: ", loaded)
		return

	# Push all props
	progress[HEIRLOOM] = loaded.get(HEIRLOOM, 0)
