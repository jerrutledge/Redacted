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

var test1:String = "My dear, Julia,

I had a butter tart and thought of you. The ones here don’t hold a candle to yours, all warm and soft. Perhaps if I pop it in the <microwave>, it might hope to compete. 

All my love, A.
"

var test2:String = "Test letter!

test test test <censor here> test!!

Sincerely, N"

var test3:String = "Tis a truth universally acknowledged, that a single man in possession of a good fortune must be in want of a <microwave>.

However little known the feelings or views of such a <brogrammer> may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered as the rightful property of some one or other of their daughters.

"
