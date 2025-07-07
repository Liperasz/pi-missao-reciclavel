extends Node2D


func _on_modo_padrao_button_up() -> void:
	global.modo_especial = false
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")

func _on_modo_especial_button_up() -> void:
	global.modo_especial = true
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
