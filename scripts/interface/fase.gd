extends Node2D

func _on_jogar_button_up() -> void:
	
	if global.modo_tempo == true:
		get_tree().change_scene_to_file("res://scenes/levelcomtempo/levelcomtempo.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level/level.tscn")

func _on_voltar_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
