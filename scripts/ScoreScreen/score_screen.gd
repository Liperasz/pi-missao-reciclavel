extends Node2D

signal fechar(acao: String)

var estrela_textura: Texture2D = load("res://assets/powers/pontuacao.png")
var background_padrao = load("res://assets/interface/pontuacao/score.png")
var background_missao = load("res://assets/interface/pontuacao/pontuacao.png")

@onready var background: TextureRect = get_node("Fundo")

func _ready():
	# Lógica de desbloqueio separada por modo
	if global.estrelas >= 1 and not global.missao_diaria:
		if global.modo_especial:
			if global.current_level == global.progresso_especial.max_level:
				global.progresso_especial.max_level += 1
		else:
			if global.current_level == global.progresso_padrao.max_level:
				global.progresso_padrao.max_level += 1
		
		# Salva o progresso após um possível desbloqueio.
		global.salvar_progresso()

	# Lógica de aparência da tela
	if global.missao_diaria:
		background.texture = background_missao
		$TextureButton2.visible = false
		$TextureButton2.disabled = true
	else:
		background.texture = background_padrao
		$TextureButton2.visible = true
		$TextureButton2.disabled = false

	# Mensagem de feedback com base nas estrelas
	if global.estrelas >= 3: $LabelFeedback.text = "Perfeito!"
	elif global.estrelas == 2: $LabelFeedback.text = "Muito bom!"
	elif global.estrelas == 1: $LabelFeedback.text = "Você conseguiu!"
	else: $LabelFeedback.text = "Tente novamente"
		
	exibir_estrelas(global.estrelas)
	
	if global.missao_diaria:
		$TextureButton/LabelButton.text = "Menu Principal"
	elif global.estrelas >= 1:
		global.som_Vitoria()
		# Verifica se o próximo nível está desbloqueado para mostrar o texto correto.
		var prox_nivel = global.current_level + 1
		var max_level_modo = global.progresso_padrao.max_level if not global.modo_especial else global.progresso_especial.max_level
		if prox_nivel <= max_level_modo:
			$TextureButton/LabelButton.text = "Próxima Fase"
		else:
			$TextureButton/LabelButton.text = "Continuar" # Ou pode ser "Menu de Fases"
	else: # 0 estrelas
		global.som_Game_over()
		$TextureButton/LabelButton.text = "Repetir fase"
		
	$TextureButton2/LabelButton.text = "Menu de Fases"

# Botão 1 (Continuar / Repetir / Menu da Missão)
func _on_texture_button_button_up() -> void:
	global.som_click()
	# A ação de "continuar" é a mesma, a lógica de avançar será na tela de fase.
	emit_signal("fechar", "continuar")
	queue_free()
	
# Botão 2 (Menu de Fases)
func _on_texture_button_2_button_up() -> void:
	global.som_click()
	emit_signal("fechar", "menu")
	queue_free()


func exibir_estrelas(estrelas : int):
	var espaco_label = 250/max(estrelas, 1)
	var qtd_estrelas_spaco = 130/max(estrelas, 1)
	for i in range(estrelas):
		var star := TextureRect.new()
		star.texture = estrela_textura
		star.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star.set_size(Vector2(128, 128))
		star.position = Vector2(i * espaco_label + qtd_estrelas_spaco, 320)
		star.name = "estrela_%d" % i
		add_child(star)
