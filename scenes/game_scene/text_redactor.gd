extends RichTextLabel
class_name CensorableRichTextLabel

var censored:Array[Vector2i] = []
var must_mask:Array[Vector2i] = []
var regex = RegEx.new()

func _ready() -> void:
	regex.compile("[^a-zA-Z0-9]") 
	bbcode_enabled = true
	selection_enabled = true
	scroll_active = true
	while text.contains("<") and text.contains(">"):
		var sel = Vector2i(text.find("<"), text.find(">") - 2)
		var newtext = text.substr(0, sel.x)
		newtext += text.substr(sel.x + 1, sel.y - sel.x+1)
		newtext += text.substr(sel.y + 3)
		text = newtext
		must_mask.append(sel)

var last_text:String = ""
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if get_selection_from() != -1:
			censored.push_back(Vector2i(get_selection_from(),get_selection_to()))
			update_censoring()
	if last_text != text:
		last_text = text
		update_censoring()

func is_alphanumeric(input) -> bool:
	# Return true if no non-alphanumeric characters were found (result is null)
	return regex.search(input) == null

func update_censoring(review = false) -> Array[int]:
	# Scores: [correctly_masked, incorrectly_masked, incorrectly_unmasked, normal_characters]
	var correctly_masked = 0
	var incorrectly_masked = 0
	var incorrectly_unmasked = 0
	var normal_characters = 0

	# List characters to censor
	var all_censored_characters:Array[int] = []
	var must_mask_characters:Array[int] = []
	for p in censored:
		for o in range(p.x, p.y + 1): ## Needs the +1 to get the next letter
			all_censored_characters.push_back(o)
	if review:
		for p in must_mask:
			for o in range(p.x, p.y + 1): ## Needs the +1 to get the next letter
				must_mask_characters.push_back(o)
	clear()
	for p in text.length():
		if all_censored_characters.has(p) and (not review or (not must_mask_characters.has(p) and not is_alphanumeric(text[p]))):
			push_fgcolor(Color.BLACK)
			add_text(text[p])
			pop_all()
		elif all_censored_characters.has(p) and review and must_mask_characters.has(p):
			push_fgcolor(Color.GREEN)
			add_text(text[p])
			pop_all()
			if is_alphanumeric(text[p]):
				correctly_masked += 1
		elif all_censored_characters.has(p) and review and not must_mask_characters.has(p):
			push_fgcolor(Color.RED)
			add_text(text[p])
			pop_all()
			if is_alphanumeric(text[p]):
				incorrectly_unmasked += 1
		elif must_mask_characters.has(p):
			push_color(Color.RED)
			add_text(text[p])
			pop_all()
			if is_alphanumeric(text[p]):
				incorrectly_masked += 1
		else:
			add_text(text[p])
			if is_alphanumeric(text[p]):
				normal_characters += 1
	print("Censoring review: %d correctly masked, %d incorrectly masked, %d incorrectly unmasked, %d normal characters" % [correctly_masked, incorrectly_masked, incorrectly_unmasked, normal_characters])
	return [correctly_masked, incorrectly_masked, incorrectly_unmasked, normal_characters]
