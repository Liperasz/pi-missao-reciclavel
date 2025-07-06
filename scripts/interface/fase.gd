extends Node2D

func _on_jogar_button_up() -> void:
	global.som_click()
	if global.modo_tempo == true:
		get_tree().change_scene_to_file("res://scenes/level/levelcomtempo.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level/level_com_vida.tscn")

func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
