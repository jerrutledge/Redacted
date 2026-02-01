extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)
## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

var level_state : LevelState
var level_time = 0
var MAX_TIME = 5 * 60  # 30 minutes in seconds
var button_state = "submit"

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

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

func _on_tutorial_button_pressed() -> void:
	open_tutorials()

func _on_submit_pressed() -> void:
	# TODO: do something with win/loss
	if button_state == "submit":
		var scores = %LetterArea.evaluate_text()
		set_score(scores)
		button_state = "next"
		%SubmitButton.text = "Next Level"
	else:
		%LetterArea.next_level()
		%SubmitButton.text = "Submit Redactions"
		button_state = "submit"
		pass

func set_score(score_object:Array[int] = [0,0,0]):
	var new_text = "Correct Masking: %d\nIncorrect Masking: %d\nMissed: %d" % [score_object[0], score_object[1], score_object[2]]
	%Score.set_text(new_text)
	level_state.score = score_object
	GlobalState.save()

func _on_timer_timeout() -> void:
	level_time -= 1  # Decrement instead of increment
	var m: int = int(level_time / 60.0)
	var s: int = level_time - m * 60
	$MarginContainer/HFlowContainer/VBoxContainer/Timer/TimerLabel.set_text('%02d:%02d' % [m, s])
	
	# Optional: Handle time running out
	if level_time <= 0:
		level_time = 0
		$Timer.stop()
		level_lost.emit()  # End the level when time runs out
