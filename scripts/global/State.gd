extends Node

@export var default_dir : String = "res://FOLDERTREE"
@export var password : String = "ok if you find this, you weren't supposed to, so just uhhh look away"
var current_directory : String = "/" :
	set(new) :
		current_directory = new
		change_prompt()
var sudo : bool = false :
	set(new) :
		sudo = new
		change_prompt()
var user : String = "loswald" :
	set(new) :
		user = new
		change_prompt()
var cons : String = "cons993" :
	set(new) :
		cons = new
		change_prompt()

var prompt : String = ""

func _ready() -> void:
	change_prompt()

func change_prompt() -> void :
	prompt = "{sudo}{user}@{console}{path}:-$ ".format({
		"sudo" : "SUPER_" if sudo else "",
		"user" : user,
		"console" : cons,
		"path" : "::"+current_directory if current_directory != "/" else "",
	})

var filesystem : Dictionary = {
	"home" : {
		"user" : {
			"LICENSE.txt" : "NOCTURNE MILITARY CONSOLE LICENSE AGREEMENT

Effective Date: December 7, 2024

This License Agreement (the “Agreement”) is made between AEGIS (the “Licensor”), recognised as a scientific superconglomerate incorporated under the laws of Western Europe, and the Licensee (hereinafter referred to as “User”). By equipping, accessing, or using the NOCTURNE Military Console (the “Console”), you agree to the terms and conditions set forth in this Agreement. If you do not agree to these terms, do not install, access, or use the Console.


1. License Grant

AEGIS grants to the User a non-exclusive, non-transferable, revocable license to install and use the NOCTURNE Military Console for the purposes of conducting information and tactical operations in accordance with the mission of NOCTURNE. The Console is licensed to the User for use in environments dedicated to maintaining peace, national security, and intelligence gathering, subject to the terms of this Agreement.


2. Restrictions on Use

The User may not:

	Reverse Engineer, Decompile, or Disassemble: The Console, its underlying code, or any other proprietary components may not be reverse-engineered, decompiled, or disassembled.
	Transfer or Resell: The License is non-transferable. The User may not rent, lease, sublicense, or distribute the Console or any part thereof.
	Unauthorized Modifications: The User is prohibited from modifying, altering, or creating derivative works based on the Console.
	Usage in Violation of Laws: The Console must not be used for illegal, harmful, or unauthorized activities, including any activities that would violate international law or the laws of the User’s governing country.



3. Ownership

The NOCTURNE Military Console, including all intellectual property rights associated with it, remains the exclusive property of AEGIS. The User acknowledges that no ownership rights are transferred under this Agreement. This License does not confer any rights of ownership in the Console or its components.


4. Security and Data Integrity

By using the Console, the User agrees to abide by the security protocols established by AEGIS and NOCTURNE. Any access, sharing, or modification of sensitive data must be conducted in accordance with the prescribed guidelines. The User must immediately report any security breach, data corruption, or unauthorized access to the Console to the designated NOCTURNE security team.


5. Confidentiality and Disclosure

The User agrees to maintain the confidentiality of any classified or sensitive information acquired or accessed through the use of the Console. Any disclosure of such information, unless explicitly authorized by AEGIS, will constitute a breach of this Agreement and may lead to the termination of the License and legal action.


6. Limited Warranty

The Console is provided \"as is.\" AEGIS does not warrant that the Console will meet the User's specific requirements, be uninterrupted, or be free from errors or defects. In no event shall AEGIS be liable for any damages arising from the use or inability to use the Console.


7. Term and Termination

This Agreement is effective from the date of acceptance until terminated by either party. AEGIS may terminate this Agreement at any time if the User violates any terms outlined herein. Upon termination, the User must cease all use of the Console and destroy all copies of the software.


8. Indemnification

The User agrees to indemnify, defend, and hold harmless AEGIS and its affiliates, directors, employees, and agents from and against any claims, losses, damages, and liabilities arising from the User’s use of the Console, including any violation of this Agreement or applicable law.


9. Governing Law

This Agreement shall be governed by and construed in accordance with the laws of Western Europe. Any disputes arising from this Agreement will be subject to the exclusive jurisdiction of the courts located in the region where AEGIS is incorporated.


10. Miscellaneous

	Entire Agreement: This Agreement constitutes the entire understanding between the parties and supersedes all prior agreements or communications related to the Console.
	Severability: If any provision of this Agreement is found to be unenforceable, the remaining provisions will remain in full effect.
	Amendment: AEGIS reserves the right to modify or update this Agreement at any time. The User will be notified of any significant changes, and continued use of the Console constitutes acceptance of the updated terms.

IN WITNESS WHEREOF, the undersigned, by using the NOCTURNE Military Console, acknowledges their agreement to the terms and conditions set forth in this License Agreement.",
			".cons_data.txt" : "CONSOLE_DATA
			username=loswald
			organisation=nocturne
			platoon=9
			squad=9
			index=3
			role=coordinator
			",
			"nocturne.png" : "res://assets/textures/empire.png",
			"p_mission" : {
				"mission_information.txt" : "",
				"context.txt" : "",
			},
			"p_private" : {
			}
		}
	}
}

func get_dir(path : String) -> Dictionary :
	var dir : Dictionary = filesystem.duplicate(true)
	if path == "/" :
		return dir
	else :
		for i in path.split("/",false) :
			if i not in dir.keys() :
				return {}
			dir = dir[i]
		return dir

func get_file(path : String) -> Array :
	var dir : Dictionary = filesystem.duplicate(true)
	if path == "/" :
		return []
	else :
		for i in path.split("/",false) :
			if i not in dir.keys() :
				return []
			elif i.contains(".") :
				return [i,dir[i]]
			dir = dir[i]
		return []

func is_valid_dir(from : String, path : String) -> bool :
	var base : Dictionary = get_dir(from + "/" + path)
	if base == {} :
		return false
	var dir : Dictionary = get_dir(from + "/" + path)
	if dir :
		return true
	return false

func is_valid_path(path:String) -> bool :
	var regex := RegEx.new()
	regex.compile("[A-Za-z_\\-\\s0-9.]+(/[A-Za-z_\\-\\s0-9.]+)*(.(txt|gif|pdf|doc|docx|xls|xlsx|js))?")
	var matchup := regex.search(path)
	if not matchup :
		return false
	if matchup.get_string() == path :
		return true
	else :
		return false

func has_perms(from:String, to : String) -> bool :
	var dir : Dictionary = filesystem.duplicate(true)
	var path : String = from + "/" + to
	if path == "/" :
		return true
	else :
		for i : String in path.split("/",false) :
			if i not in dir.keys() :
				return true
			elif i.to_lower().begins_with("p_") :
				return State.sudo
			elif i.contains(".") :
				return true
			dir = dir[i]
		return true
