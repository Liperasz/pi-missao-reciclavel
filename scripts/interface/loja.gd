extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_item_1_button_up() -> void:
	item_selected(1)

func _on_item_2_button_up() -> void:
	item_selected(2)

func _on_item_3_button_up() -> void:
	item_selected(3)

func _on_item_4_button_up() -> void:
	item_selected(4)

func _on_item_5_button_up() -> void:
	item_selected(5)

func _on_item_6_button_up() -> void:
	item_selected(6)

func _on_comprar_1_button_up() -> void:
	pass

func _on_comprar_2_button_up() -> void:
	pass

func _on_comprar_3_button_up() -> void:
	pass

func _on_comprar_4_button_up() -> void:
	pass

func _on_comprar_5_button_up() -> void:
	pass

func _on_comprar_6_button_up() -> void:
	pass

func _on_voltar_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")

func item_selected(item: int):
	get_tree().change_scene_to_file("res://scenes/interface/item.tscn")
