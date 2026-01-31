extends Node

@export var starting_index = 1


func _ready() -> void:
	if (starting_index == 1):
		%LetterText.text = test1
	else:
		%LetterText.text = test2

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
