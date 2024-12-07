extends VBoxContainer
class_name ConsoleManager

var tween: Tween
func intro_sequence(intro_label: Label) -> Error:
	for each in self.get_children():
		each.hide()
	intro_label.text = ""
	intro_label.show()

	#await TextUtils.text_anim_dots(intro_label, "BOOTING UP", 0.1, 2.0, true)
	#await TextUtils.text_anim_dots(intro_label, "Recovering console journal-log", 0.3, 1.0, true)
	#await TextUtils.text_anim_count(intro_label, "Searching for unlinked nodes", randi_range(32,129), 0.4, 0.01, true)
	var project_string := r"
								  _______  _______  _______ _________ _______  _______ _________
								 (  ____ )(  ____ )(  ___  )\__    _/(  ____ \(  ____ \\__   __/
								 | (    )|| (    )|| (   ) |   )  (  | (    \/| (    \/   ) (   
								 | (____)|| (____)|| |   | |   |  |  | (__    | |         | |
								 |  _____)|     __)| |   | |   |  |  |  __)   | |         | |
								 | (      | (\ (   | |   | |   |  |  | (      | |         | |   
								 | )      | ) \ \__| (___) ||\_)  )  | (____/\| (____/\   | |   
								 |/       |/   \__/(_______)(____/   (_______/(_______/   )_(   
															  
					 _______  _______  _______  _______  _______ _________          _______           _______
					(  ____ )(  ____ )(  ___  )(       )(  ____ \\__   __/|\     /|(  ____ \|\     /|(  ____ \
					| (    )|| (    )|| (   ) || () () || (    \/   ) (   | )   ( || (    \/| )   ( || (    \/
					| (____)|| (____)|| |   | || || || || (__       | |   | (___) || (__    | |   | || (_____
					|  _____)|     __)| |   | || |(_)| ||  __)      | |   |  ___  ||  __)   | |   | |(_____  )
					| (      | (\ (   | |   | || |   | || (         | |   | (   ) || (      | |   | |      ) |
					| )      | ) \ \__| (___) || )   ( || (____/\   | |   | )   ( || (____/\| (___) |/\____) |
					|/       |/   \__/(_______)|/     \|(_______/   )_(   |/     \|(_______/(_______)\_______)
																						  
					The Prometheus Project (codename by ███████████) is a squad mission to [REDACTED], Russia,
					involving squads ████████████, █████████████████████, and  ██████████. The objective is to 
					████████████████████████████████████████████████████████████████████████ (primary), and to
					retrieve data on cold-blooded signatures in area #███████████. This mission is financed by
					███████████████████████████, and commandited by ████████████████████████████, the Nocturne
					Board of Commandement, and ██████████.
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					██████████████████████████████████████████████████████████████████████████████████████████
					
					
					
"
	await GeneralUtils.wait(0.5)
	var history : Array[String] = []
	while true :
		var prompt : ConsolePrompt = (load("res://scenes/console/console_prompt.tscn") as PackedScene).instantiate()
		add_child(prompt)
		prompt.history = history
		prompt.line_edit.grab_focus()
		(get_parent() as ScrollContainer).scroll_vertical += 999999
		var sub : String
		sub = await prompt.line_edit.text_submitted
		if sub :
			history.push_front(sub)
		prompt.line_edit.editable = false
		prompt.line_edit.selecting_enabled = false
		var output_label := Label.new()
		output_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		Exec.output_label = output_label
		await Exec.exec_command(sub)
		add_child(output_label)
		output_label.grab_focus()
		(get_parent() as ScrollContainer).scroll_vertical += 999999
	return OK

func _ready() -> void:
	var intro_label: Label = Label.new()
	self.add_child(intro_label)
	Exec.console_manager = self
	Exec.clear_console.connect(
		func () :
			for child in get_children() :
				child.queue_free()
	)
	await intro_sequence(intro_label)

func clean() -> Error :
	for each in self.get_children() :
		each.queue_free()
	return OK
