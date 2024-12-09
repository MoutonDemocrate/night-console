extends Node

var output_label : Label
var console_manager : ConsoleManager

signal clear_console

func exec_command(line : String) :
	var sep := line.split(" ", false)
	if not line or not sep :
		output_label.text = "No command entered. Use \"help\" for a list of commands in console path."
		return
	var method_list = get_method_list().map(func (dic:Dictionary) : return dic["name"])
	if sep[0] in method_list :
		if sep[0] == "exec_command" :
			return
		await callv(sep[0], [sep.slice(1)])
	else :
		output_label.text = "Command not in path. Use \"help\" for a list of commands in console path."
		return

func help(args : PackedStringArray) -> void :
	output_label.text = "Command List
pwd     Print Working Directory
cd      Change Directory
ls      List files in working directory
clear   Clear console output
read    Prints content of text file to console output
png     Prints image to console screen
su      Become superuser".replace("\t","    ")

func su(args : PackedStringArray) -> void :
	print("su called with args : ", args)
	var invalid := "su :: {error} : {detail}\nUse -h to print help."
	var help := "Become superuser

USAGE : clear [OPTIONS] [PSW]

OPTIONS :
	-S		Supersudo (ADMINISTRATICE ACCESS, DO NOT USE)
	-h		Print help information".replace("\t", "    ")
	
	var supersu : bool = false
	
	if args :
		for arg in args :
			match arg :
				"-h" :
					output_label.text = help
					return
				"-S" :
					supersu = true
				_ : 
					if arg == State.password and not supersu :
						output_label.text = "Correct password, you are now superuser."
						State.sudo = true
					elif arg == State.noc_password and supersu :
						output_label.text = "CORRECT PASSWORD - WELCOME BACK, ADMINISTRATOR"
						State.supersudo = true
					else :
						output_label.text = invalid.format({"error" : "wrong password", "detail" : "this incident will be reported"})
					return
					
	output_label.text = invalid.format({"error" : "no password", "detail" : "you must input a password"})
	return

func pwd(args : PackedStringArray) -> void :
	print("pwd called with args : ", args)
	if args :
		if "-h" in args :
			output_label.text = "Print Working Directory

USAGE : pwd [OPTIONS]

OPTIONS :
	-h		Print help information".replace("\t", "    ")
			return
		
		output_label.text = "pwd :: unrecognised options : " + (Array(args) as Array[String]).reduce((
			func (accum:String,arg:String) : return accum + ", " + arg),"")
		output_label.text += "\nUse -h to print help."
		return
	output_label.text = State.current_directory
	return

func ls(args : PackedStringArray) -> void :
	print("ls called with args : ", args)
	var invalid := "ls :: {error} : {detail}\nUse -h to print help."
	var help := "List working directory files

USAGE : ls [OPTIONS] [PATH]

OPTIONS :
	-R		Recursive, prints filesystem tree using current directory as root.
	-h		Print help information".replace("\t", "    ")
	
	var rec := func (path : String, f : Callable, depth :int = 0, recursive := true) :
		var keys : Array = State.get_dir(path).keys()
		var hidden_keys : Array = []
		return Array(keys).reduce((
			func (accum:String,key:String) :
				if recursive :
					print(key,", from path ", path)
					if State.has_perms(State.current_directory, path) :
						if State.get_dir(path)[key] is Dictionary:
							return accum + "\n" + " ".repeat(depth) + ":: " + f.call(path + "/" + key,f,depth+len(key),true)
						else :
							return accum + "\n" + " ".repeat(depth) + ":: " + key
					else :
						if path in hidden_keys :
							return accum
						else :
							hidden_keys.append(path)
							return accum + " :: " + "INSUFFICIENT PERMS"

				else :
					return accum + "\n" + ":: " + key
		), path.split("/")[-1] if path != "/" else "root")
	
	var recursive := false
	
	if args :
		for arg in args :
			match arg :
				"-R" :
					recursive = true
				"-h" :
					output_label.text = help
					return
				_ : 
					if not State.is_valid_path(arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid path"})
						return
					if not State.is_valid_dir(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid directory"})
						return
					if not State.has_perms(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "insufficient permissions"})
						return
					output_label.text = str(rec.call(State.current_directory + "/" + arg,rec,0,recursive))
					return
	output_label.text = str(rec.call(State.current_directory,rec,0,recursive))
	return

func cd(args : PackedStringArray) -> void :
	print("cd called with args : ", args)
	var invalid := "cd :: {error} : {detail}\nUse -h to print help."
	var help := "Change directory

USAGE : cd [OPTIONS] [PATH]

OPTIONS :
	-h		Print help information".replace("\t", "    ")
	
	if args :
		for arg in args :
			match arg :
				"-h" :
					output_label.text = help
					return
				_ : 
					if not State.is_valid_path(arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid path"})
						return
					if not State.is_valid_dir(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid directory"})
						return
					if not State.has_perms(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "insufficient permissions"})
						return
					State.current_directory = State.current_directory + "/" + arg
					return
	State.current_directory = "/"
	return

func read(args : PackedStringArray) -> void :
	print("read called with args : ", args)
	var invalid := "read :: {error} : {detail}\nUse -h to print help."
	var help := "Read text file

USAGE : read [OPTIONS] [PATH]

OPTIONS :
	-h		Print help information".replace("\t", "    ")
	
	if args :
		for arg in args :
			match arg :
				"-h" :
					output_label.text = help
					return
				_ : 
					if not State.is_valid_path(arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid path"})
						return
					if not State.get_file(State.current_directory + "/" + arg)[0].split(".")[-1] == "txt" :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid text file"})
						return
					if not State.has_perms(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "insufficient permissions"})
						return
					var file : Array = State.get_file(State.current_directory + "/" + arg)
					var fn : String = file[0]
					var ft : String = file[1]
					output_label.text = "\n" + ft + "\n"
					return
	output_label.text = invalid.format({"error" : "wrong input", "detail" : "no file path"})
	return
	
func clear(args : PackedStringArray) -> void :
	print("clear called with args : ", args)
	var invalid := "clear :: {error} : {detail}\nUse -h to print help."
	var help := "Clears console output

USAGE : clear [OPTIONS]

OPTIONS :
	-h		Print help information".replace("\t", "    ")
	
	if args :
		for arg in args :
			match arg :
				"-h" :
					output_label.text = help
					return
				_ : 
					output_label.text = invalid.format({"error" : arg, "detail" : "options not found"})
					return
					
	clear_console.emit()
	return

func png(args : PackedStringArray) -> void :
	print("png called with args : ", args)
	var invalid := "png :: {error} : {detail}\nUse -h to print help."
	var help := "Prints image file to console output

USAGE : png [OPTIONS] [PATH]

OPTIONS :
	-h		Print help information".replace("\t", "    ")
	
	if args :
		for arg in args :
			match arg :
				"-h" :
					output_label.text = help
					return
				_ : 
					if not State.is_valid_path(arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid path"})
						return
					if not State.get_file(State.current_directory + "/" + arg)[0].split(".")[-1] in ["png","jpg"] :
						output_label.text = invalid.format({"error" : arg, "detail" : "not a valid image file"})
						return
					if not State.has_perms(State.current_directory, arg) :
						output_label.text = invalid.format({"error" : arg, "detail" : "insufficient permissions"})
						return
					var file : Array = State.get_file(State.current_directory + "/" + arg)
					var fn : String = file[0]
					var ft : String = file[1]
					var image : TextureRect = TextureRect.new()
					image.texture = load(ft)
					image.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
					image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					image.size_flags_vertical = Control.SIZE_FILL
					console_manager.add_child(image)
					return
					
	output_label.text = invalid.format({"error" : "wrong input", "detail" : "no image file path"})
	return
