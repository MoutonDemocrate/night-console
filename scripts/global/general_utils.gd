extends Node

func wait(time : float) -> Error :
	await get_tree().create_timer(time).timeout
	return OK

var save_path : String = "user://save.txt"
