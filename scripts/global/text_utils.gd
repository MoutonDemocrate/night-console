extends Node

## Animates typing on a Label's text.
func text_anim_manual_entry(lab: Label, entry: String, ch: float, s: float, sfx: String = "", random: float = 0.0, additive: bool = true) -> Error:
	
	if not additive:
		lab.text = ""

	var curr_char := 0
	var sfxPlayer := AudioStreamPlayer.new()
	
	if sfx != "":
		sfxPlayer.stream = load(sfx)
	
	while curr_char < len(entry):
		lab.text += entry[curr_char]
		curr_char += 1
		if sfx != "":
			sfxPlayer.play()
		
		await get_tree().create_timer(s / ch + (randf() - 0.5) * random).timeout
	return OK
		
func text_anim_dots(label: Label, txt: String, t: float, td: float, additive: bool = false) -> Error:
	if additive:
		txt = label.text + "\n" + txt
	var tween := create_tween()
	tween.tween_property(label, "text", txt, t)
	tween.tween_property(label, "text", txt + "...", td)
	await tween.finished
	return OK

func text_anim_count(label: Label, txt: String, count: int, t: float, td: float, additive: bool = false) -> Error:
	if additive:
		txt = label.text + "\n" + txt
	var tween := create_tween()
	tween.tween_property(label, "text", txt, t)
	for i in range(0, count + 1):
		tween.tween_property(label, "text", txt + "(" + str(i) + ")", td)
	await tween.finished
	return OK

func text_anim_line_by_line_over(label: Label, txt: String, over: float, percent: float = 0.8, additive: bool = false) -> Error:
	var line_array: PackedStringArray = txt.split("\n")
	txt = ""
	if additive:
		txt = label.text + "\n" + txt
	var tween := create_tween()
	for line: String in line_array:
		txt = txt + line + "\n"
		tween.tween_property(label, "text", txt, over / float(len(line_array)) * percent)
	await tween.finished
	return OK

func text_anim_line_by_line(label: Label, txt: String, time_per_character: float = 0.05, additive: bool = false) -> Error:
	var line_array: PackedStringArray = txt.split("\n")
	txt = ""
	if additive:
		txt = label.text + "\n" + txt
	var tween := create_tween()
	for line: String in line_array:
		txt = txt + line + "\n"
		tween.tween_property(label, "text", txt, time_per_character * len(line))
	await tween.finished
	return OK

func text_anim_loading(label: Label, txt: String, base_text_t: float, load_t: float, charac_time: float = 0.1, load_seq: String = "-/|\\◯", additive: bool = false) -> Error:
	if additive:
		txt = label.text + "\n" + txt
	var tween := create_tween()
	tween.tween_property(label, "text", txt, base_text_t)
	for i in range(0, floor(load_t / charac_time)):
		tween.tween_property(label, "text", txt + " " + load_seq[i % len(load_seq) - 1], charac_time)
	tween.tween_property(label, "text", txt + " " + load_seq[len(load_seq) - 1], charac_time)
	await tween.finished
	return OK

func text_anim_dl_list(label: Label, dl_list: Array[Array], load_seq: String = "-▓", total_size: int = 132, additive: bool = false) -> Error:
	for i in range(len(dl_list)):
		var tween := create_tween()
		var dl: Array = dl_list[i]
		var empty_bar: String = dl[0] + " [" + load_seq[0].repeat(total_size - len(dl[0]) - 3) + "]"
		var full_bar: String = dl[0] + " [" + load_seq[1].repeat(total_size - len(dl[0]) - 3) + "]"
		var txt: String = label.text + "\n" if additive else ""
		tween.tween_property(label, "text", txt + empty_bar, 0.1)
		tween.tween_property(label, "text", txt + full_bar, dl[1])
		txt += full_bar + "\n"
		await tween.finished
		await GeneralUtils.wait(maxf(dl[1] * 0.1, 0.5))
		
	return OK
