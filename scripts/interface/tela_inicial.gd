extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_jogar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/escolher_modo.tscn")


func _on_missoes_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/missoes_diarias.tscn")


func _on_loja_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/loja.tscn")


func _on_configuracoes_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/configuracoes.tscn")
