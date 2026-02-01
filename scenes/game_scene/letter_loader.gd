extends Node

@export var starting_index = 0
var current_index = starting_index
@export var level_folder_name = "level1"
var letter_strings: Array[String] = []

func _ready() -> void:
	print("ASDASDSADASDA")
	var path:String = "res://resources/level_letters/"+level_folder_name
	
	var dir = DirAccess.open(path)
	if dir:
		print("Opened folder+ "+path)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var file
		while file_name != "":
			file = FileAccess.open(path+"/"+file_name, FileAccess.READ)
			letter_strings.append(file.get_as_text())
			print("found file name: "+file_name)
			file_name = dir.get_next()
		var a = 1
	else:
		return
	
	
	%LetterText.set_letter_text(letter_strings[current_index])


func evaluate_text() -> Array[int]:
	return %LetterText.update_censoring(true)
	
func next_level() -> bool:
	var end_level = false
	if current_index < len(letter_strings)-1:
		current_index += 1
	else:
		end_level = true
	%LetterText.set_letter_text(letter_strings[current_index])
	%LetterText.update_censoring()
	return end_level
	
