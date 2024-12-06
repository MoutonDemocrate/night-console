extends VBoxContainer
class_name ConsoleManager

var tween: Tween
func intro_sequence(intro_label: Label) -> Error:
	for each in self.get_children():
		each.hide()
	intro_label.text = ""
	intro_label.show()

	await TextUtils.text_anim_dots(intro_label, "BOOTING UP", 0.1, 3.0, true)
	await TextUtils.text_anim_dots(intro_label, "Recovering console journal-log", 0.3, 1.0, true)
	await TextUtils.text_anim_count(intro_label, "Searching for unlinked nodes", randi_range(32,129), 0.4, 0.05, true)
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
	await GeneralUtils.wait(1.5)
	var shell_label : Label = Label.new()
	shell_label.text = "╭─[NOCTURNE_SHELL]"
	self.add_child(shell_label)
	var pointer_menu : VBoxConsoleSelection = VBoxConsoleSelection.new()
	pointer_menu.menu_deco = "╰───▶ "
	pointer_menu.add_pointer_label("Project Prometheus -- Briefing")
	pointer_menu.add_pointer_label("Kill Shell")
	self.add_child(pointer_menu)
	var result : int = await pointer_menu.pointer_selected
	pointer_menu.queue_free()
	match result:
		0:
			print("Identify")
			var shell_arrow : Label = Label.new()
			shell_arrow.text = "╰───▶ "
			self.add_child(shell_arrow)
			await TextUtils.text_anim_manual_entry(shell_arrow,"id -p RossiAlessia\n",15,1, "", 0.1, true)
			var post_id_label : Label = Label.new()
			post_id_label.text = ""
			self.add_child(post_id_label)
			await TextUtils.text_anim_loading(post_id_label,"Checking ID from Nocturne database",0.2,2.3,0.1,"-/|\\◯",true)
			await create_tween().tween_property(post_id_label, "text", post_id_label.text + "\nIdentification successful. Tier 8 access granted.", 0.1).finished
			await GeneralUtils.wait(1.2)
			await TextUtils.text_anim_loading(post_id_label,"Loading profile from profile manager",0.2,1.2,0.1,"-/|\\◯",true)
			# 132
			var post_id_dl : Array[Array]= [["Logging database access in journal-log...", 0.2],
			["Checking for base module upgrade...", 3.6],
			["Downloading \"nocturne-foundation-base-3.1.23\"... ", 2.4],
			["Unpacking \"nocturne-foundation-base-3.1.23\"...", 7.8],
			["Downloading \"nocturne-foundation-extras-3.1.45\"... ", 1.4],
			["Unpacking \"nocturne-foundation-extras-3.1.45\"...", 2.2],
			["Downloading \"nocturne-foundation-hackmod-3.1.12\"... ", 1.4],
			["Unpacking \"nocturne-foundation-hackmod-3.1.12\"...", 2.2],
			["Downloading \"NightEyePir\"... ", 7.2],
			["Unpacking \"NightEyePir\"...", 5.4]]
			await TextUtils.text_anim_dl_list(post_id_label, post_id_dl, "-░▒▓█",132,true)
		1:
			print("Kill The Console")
			var shell_arrow : Label = Label.new()
			shell_arrow.text = "╰───▶ "
			self.add_child(shell_arrow)
			await TextUtils.text_anim_manual_entry(shell_arrow,"exit\n",15,1, "", 0.1, true)
			await GeneralUtils.wait(0.6)
			$"../../..".hide()
			await GeneralUtils.wait(2.3)
			JavaScriptBridge.eval("window.close()")
			get_tree().root.queue_free()
			JavaScriptBridge.eval("window.close()")
		_:
			push_error("PointerMenu ("+pointer_menu.name+") returned an invalid index.")
			return ERR_UNAUTHORIZED
	return OK

func _ready() -> void:
	var intro_label: Label = Label.new()
	self.add_child(intro_label)
	await intro_sequence(intro_label)

func clean() -> Error :
	for each in self.get_children() :
		each.queue_free()
	return OK
