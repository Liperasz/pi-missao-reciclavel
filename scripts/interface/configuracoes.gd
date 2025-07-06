extends Node2D

func _ready() -> void:
	global.som_Entrada()
	
func _on_aumentar_button_up() -> void:
	if global.volume < 100:
		global.volume += 3
		alterar_volume(global.volume)
		global.som_click()
		
func _on_diminuir_button_up() -> void:
	if global.volume > 0:
		global.volume -= 3
		alterar_volume(global.volume)
		global.som_click()
		
func _on_mutar_button_up() -> void:
	global.volume = -80
	alterar_volume(global.volume)
	
func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
	
func alterar_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
