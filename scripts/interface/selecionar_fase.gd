extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")


func _on_fase_1_button_up() -> void:
	global.som_click()
	global.player_level = 1
	select_level(1)


func _on_fase_2_button_up() -> void:
	global.som_click()
	global.player_level = 2
	select_level(2)


func _on_fase_3_button_up() -> void:
	global.som_click()
	global.player_level = 3
	select_level(3)


func _on_fase_4_button_up() -> void:
	global.som_click()
	global.player_level = 4
	select_level(4)


func _on_fase_5_button_up() -> void:
	global.som_click()
	global.player_level = 5
	select_level(5)


func _on_fase_6_button_up() -> void:
	global.som_click()
	global.player_level = 6
	select_level(6)

func select_level(level: int):
	get_tree().change_scene_to_file("res://scenes/interface/fase.tscn")
