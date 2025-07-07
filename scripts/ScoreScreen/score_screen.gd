extends Node2D

signal fechar(acao: String)

var estrela_textura: Texture2D = load("res://assets/powers/pontuacao.png")
var background_padrao = load("res://assets/interface/pontuacao/score.png")
var background_missao = load("res://assets/interface/pontuacao/pontuacao.png")

@onready var background: TextureRect = get_node("Fundo")

func _ready():
	
	# Se o jogador passou de fase E estava jogando o nível mais alto disponível...
	if global.estrelas >= 1 and global.current_level == global.max_level:
		# desbloqueia o próximo nível.
		global.max_level += 1
		global.salvar_progresso()
	
	if global.missao_diaria:
		background.texture = background_missao
		$TextureButton2.visible = false
		$TextureButton2.disabled = true
	else:
		background.texture = background_padrao
		$TextureButton2.visible = true
		$TextureButton2.disabled = false

	# Mensagem de feedback
	if global.estrelas >= 3: $LabelFeedback.text = "Perfeito!"
	elif global.estrelas == 2: $LabelFeedback.text = "Muito bom!"
	elif global.estrelas == 1: $LabelFeedback.text = "Você conseguiu!"
	else: $LabelFeedback.text = "Tente novamente"
		
	exibir_estrelas(global.estrelas)
	
	# Define o texto dos botões
	if global.missao_diaria:
		$TextureButton/LabelButton.text = "Menu Principal"
	elif global.estrelas >= 1:
		global.som_Vitoria()
		# O texto agora mostra o nível que acabou de ser desbloqueado
		$TextureButton/LabelButton.text = "Continuar"
	else:
		global.som_Game_over()
		$TextureButton/LabelButton.text = "Repetir fase"
		
	$TextureButton2/LabelButton.text = "Menu de Fases"

# Botão 1 (Continuar / Repetir / Menu da Missão)
func _on_texture_button_button_up() -> void:
	global.som_click()
	# A ação "continuar" agora é genérica. A tela de nível decidirá o que fazer.
	emit_signal("fechar", "continuar")
	queue_free()
	
# Botão 2 (Menu Principal)
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
		star.position = Vector2(i * espaco_label + qtd_estrelas_spaco, 320)  # 100 = margem esquerda
		star.name = "estrela_%d" % i
		add_child(star)
