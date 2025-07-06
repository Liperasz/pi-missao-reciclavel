extends Node2D


func _on_levelcomtempo_button_up() -> void:
	global.modo_tempo = true
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")

func _on_levelcomvidas_button_up() -> void:
	global.modo_tempo = false
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
