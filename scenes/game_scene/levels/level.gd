extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)
## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

var level_state : LevelState
var level_time = 0
var MAX_TIME = 5 * 60  # 5 minutes in seconds
var button_state = "submit"

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

func handle_level_change(next_level_path: String):
	if scene_file_path.contains("level_3"):
		print("on third level`")
		show_completion_message()
		go_to_main_screen()
	else:
		level_won.emit(next_level_path)

func show_completion_message() -> void:
	# Create and display a completion message
	var dialog = AcceptDialog.new()
	dialog.title = "Congratulations!"
	dialog.dialog_text = "You have completed all levels!"
	add_child(dialog)
	dialog.popup_centered_ratio(0.5)
	
func go_to_main_screen() -> void:
	# Navigate to main screen (adjust the path based on your project structure)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
	
func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	level_time = MAX_TIME  # Start at max time
	$Timer.start(1.0)  # Tick every second
	if not level_state.tutorial_read:
		open_tutorials()
	set_score(level_state.score)
	%SubmitButton.text = "SEND"

func _on_tutorial_button_pressed() -> void:
	open_tutorials()

func _on_submit_pressed() -> void:
	# TODO: do something with win/loss
	var end_level
	if button_state == "submit":
		var scores = %LetterArea.evaluate_text()
		set_score(scores)
		button_state = "next"
		%SubmitButton.text = "NEXT"
	else:
		end_level = %LetterArea.next_level()
		if end_level:
			handle_level_change(next_level_path)
			#level_won.emit(next_level_path)
		%SubmitButton.text = "SEND"
		button_state = "submit"

func set_score(score_object:Array[int] = [0,0,0]):
	for i in range(3):
		level_state.score[i] += score_object[i]
	GlobalState.save()
	var new_text = "Correct Masking: %d\nIncorrect Masking: %d\nMissed: %d" % [level_state.score[0], level_state.score[1], level_state.score[2]]
	%Score.set_text(new_text)

func _on_timer_timeout() -> void:
	level_time -= 1  # Decrement instead of increment
	var m: int = int(level_time / 60.0)
	var s: int = level_time - m * 60
	$MarginContainer/HFlowContainer/VBoxContainer/Timer/TimerLabel.set_text('%02d:%02d' % [m, s])
	
	# Optional: Handle time running out
	if level_time <= 0:
		level_time = 0
		$Timer.stop()
		level_won.emit(next_level_path)  # End the level when time runs out
