extends Node2D
@onready var estrelas: Label = $estrelas
func _ready() -> void:
	estrelas.text = str(global.saldo_estrelas)
	pass
func atualizar_display_estrelas():
	estrelas.text = str(global.saldo_estrelas)
	
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
	if global.saldo_estrelas >= 2:
		global.saldo_estrelas -= 2
		global.poderes[1]["quantidade"] += 1
		atualizar_display_estrelas()
	else:
		print("Sem estrelas suficiente :(")

func _on_comprar_2_button_up() -> void:
	if global.saldo_estrelas >= 3:
		global.saldo_estrelas -= 3
		global.poderes[2]["quantidade"] += 1
		atualizar_display_estrelas()
	else:
		print("Sem estrelas suficiente :(")
func _on_comprar_3_button_up() -> void:
	if global.saldo_estrelas >= 4:
		global.saldo_estrelas -= 4
		global.poderes[3]["quantidade"] += 1
		atualizar_display_estrelas()
	else:
		print("Sem estrelas suficiente :(")
func _on_comprar_4_button_up() -> void:
	if global.saldo_estrelas >= 2:
		global.saldo_estrelas -= 2
		global.poderes[4]["quantidade"] += 1
		atualizar_display_estrelas()
	else:
		print("Sem estrelas suficiente :(")
func _on_comprar_5_button_up() -> void:
	if global.saldo_estrelas >= 6:
		global.saldo_estrelas -= 6
		global.poderes[5]["quantidade"] += 1
		atualizar_display_estrelas()
	else:
		print("Sem estrelas suficiente :(")
func _on_comprar_6_button_up() -> void:
	pass

func _on_voltar_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")

func item_selected(item: int):
	global.item_selecionado = item  
	get_tree().change_scene_to_file("res://scenes/interface/item.tscn")
