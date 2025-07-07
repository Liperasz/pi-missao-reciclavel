extends Node2D

@onready var botoes_fase = [
	$Fase1,
	$Fase2,
	$Fase3,
	$Fase4,
	$Fase5,
	$Fase6
]

func _ready() -> void:
	# Determina qual 'max_level' usar com base no modo de jogo.
	var nivel_maximo_atual = global.progresso_padrao.max_level
	if global.modo_especial:
		nivel_maximo_atual = global.progresso_especial.max_level
		
	# Atualiza a aparência dos botões com base no progresso do modo atual.
	for i in botoes_fase.size():
		var level_num = i + 1
		var botao = botoes_fase[i]
		
		if level_num > nivel_maximo_atual:
			botao.disabled = true
			botao.modulate = Color(0.5, 0.5, 0.5, 0.7)
		else:
			botao.disabled = false
			botao.modulate = Color(1, 1, 1, 1)


func select_level(level: int):
	# Determina qual 'max_level' usar para a verificação.
	var nivel_maximo_atual = global.progresso_padrao.max_level
	if global.modo_especial:
		nivel_maximo_atual = global.progresso_especial.max_level

	if level <= nivel_maximo_atual:
		global.som_click()
		global.current_level = level
		get_tree().change_scene_to_file("res://scenes/interface/fase.tscn")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/escolher_modo.tscn")


func _on_fase_1_button_up() -> void: select_level(1)
func _on_fase_2_button_up() -> void: select_level(2)
func _on_fase_3_button_up() -> void: select_level(3)
func _on_fase_4_button_up() -> void: select_level(4)
func _on_fase_5_button_up() -> void: select_level(5)
func _on_fase_6_button_up() -> void: select_level(6)
