extends Control

func _ready():
	$RestartButton.pressed.connect(_on_restart_pressed)
	$ExitButton.pressed.connect(_on_exit_pressed)


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_exit_pressed():
	get_tree().quit()
