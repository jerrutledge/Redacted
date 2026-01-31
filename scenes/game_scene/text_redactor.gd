extends RichTextLabel
class_name CensorableRichTextLabel

var censored:Array[Vector2i] = []
var must_mask:Array[Vector2i] = []

func _ready() -> void:
	bbcode_enabled = true
	selection_enabled = true
	scroll_active = true
	while text.contains("<"):
		var sel = Vector2i(text.find("<"), text.find(">") - 1)
		var newtext = text.substr(0, sel.x) 
		newtext += text.substr(sel.x + 1, sel.y - sel.x)
		newtext += text.substr(sel.y + 2)
		text = newtext

var last_text:String = ""
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if get_selection_from() != -1:
			censored.push_back(Vector2i(get_selection_from(),get_selection_to()))
			update_censoring()
	if last_text != text:
		last_text = text
		update_censoring()

func update_censoring():
	var all_censored_characters:Array[int] = []
	for p in censored:
		for o in range(p.x, p.y + 1): ## Needs the +1 to get the next letter
			all_censored_characters.push_back(o)
	clear()
	for p in text.length():
		if all_censored_characters.has(p):
			push_fgcolor(Color.BLACK)
			add_text(text[p])
			pop_all()
		else:
			add_text(text[p])

func reveal_censoring():
	pass
