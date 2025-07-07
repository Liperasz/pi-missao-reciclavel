extends Node2D

@onready var label_titulo: Label = get_node("LabelTituloFase")
@onready var label_recorde: Label = get_node("LabelRecorde")
@onready var estrelas_container: HBoxContainer = get_node("EstrelasContainer")

var estrela_textura: Texture2D = preload("res://assets/powers/pontuacao.png")


func _ready() -> void:
	var nivel_atual = global.current_level
	label_titulo.text = "Fase " + str(nivel_atual)
	var nome_fase_chave = "Fase " + str(nivel_atual)
	
	# Verifica se o jogador já tem algum progresso salvo para esta fase.
	if global.fases_completas.has(nome_fase_chave):
		# Pega os dados salvos para esta fase.
		var dados_fase = global.fases_completas[nome_fase_chave]
		
		var estrelas_ganhas = 0
		var pontuacao_recorde = 0
		
		estrelas_ganhas = dados_fase.get("estrelas", 0)
		pontuacao_recorde = dados_fase.get("pontos", 0)
		label_recorde.text = "Recorde:\n" + str(pontuacao_recorde) + " pontos"
		
		exibir_estrelas(estrelas_ganhas)
	else:
		# Se nunca jogou esta fase.
		label_recorde.text = "Jogue para \ndefinir um \nrecorde!"
		exibir_estrelas(0)


func exibir_estrelas(quantidade: int):
	estrelas_container.alignment = HBoxContainer.ALIGNMENT_CENTER
	
	estrelas_container.add_theme_constant_override("separation", -15)
	
	for child in estrelas_container.get_children():
		child.queue_free()
		
	for i in range(quantidade):
		var star_icon = TextureRect.new()
		star_icon.texture = estrela_textura
		star_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		star_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		star_icon.custom_minimum_size = Vector2(100, 100)
		
		estrelas_container.add_child(star_icon)


func _on_jogar_button_up() -> void:
	global.som_click()
	if global.modo_especial == true:
		if global.current_level % 2 == 0:
			get_tree().change_scene_to_file("res://scenes/level/levelcomtempo.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/level/level_com_vida.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level/level_padrao.tscn")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
