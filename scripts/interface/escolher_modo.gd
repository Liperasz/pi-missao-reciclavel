extends Node2D


func _on_levelcomtempo_button_up() -> void:
	global.modo_tempo = true
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")

func _on_levelcomvidas_button_up() -> void:
	global.modo_tempo = false
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
