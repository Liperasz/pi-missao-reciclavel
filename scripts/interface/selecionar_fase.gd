extends Node2D

@onready var botoes_fase = [
	$Fase1,
	$Fase2,
	$Fase3,
	$Fase4,
	$Fase5,
	$Fase6
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in botoes_fase.size():
		var level_num = i + 1
		var botao = botoes_fase[i]
		
		if level_num > global.max_level:
			# Se o nível ainda não foi desbloqueado
			botao.disabled = true
			botao.modulate = Color(0.5, 0.5, 0.5, 0.7) # Deixa o botão cinza/transparente
		else:
			# Se o nível está desbloqueado
			botao.disabled = false
			botao.modulate = Color(1, 1, 1, 1) # Cor normal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func select_level(level: int):
	# Apenas permite selecionar se o nível estiver desbloqueado
	if level <= global.max_level:
		global.som_click()
		global.current_level = level
		get_tree().change_scene_to_file("res://scenes/interface/fase.tscn")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/escolher_modo.tscn")


func _on_fase_1_button_up() -> void:
	select_level(1)


func _on_fase_2_button_up() -> void:
	select_level(2)


func _on_fase_3_button_up() -> void:
	select_level(3)


func _on_fase_4_button_up() -> void:
	select_level(4)


func _on_fase_5_button_up() -> void:
	select_level(5)


func _on_fase_6_button_up() -> void:
	select_level(6)
