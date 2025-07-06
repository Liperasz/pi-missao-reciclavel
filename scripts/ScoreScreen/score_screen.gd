extends Node2D

signal fechar

var estrela_textura: Texture2D = load("res://assets/powers/pontuacao.png")

func _ready():

#mensagem conforme seu desenvolvimento
	if global.estrelas == 3:
		$LabelFeedback.text = "Perfeito!"
	elif global.estrelas == 2:
		$LabelFeedback.text = "Muito bom!"
	elif global.estrelas == 1:
		$LabelFeedback.text = "Você conseguiu!"
	else:
		$LabelFeedback.text = "Tente novamente"
		
	exibir_estrelas(global.estrelas)
	# Texto do botão (LabelButton está dentro do TextureButton)
	if global.estrelas >= 1:
		global.som_Vitoria()
		$TextureButton/LabelButton.text = "Jogar fase " +str(global.player_level + 1)
		global.player_level += 1
	else:
		global.som_Game_over()
		$TextureButton/LabelButton.text = "Repetir fase " +str(global.player_level)


func _on_texture_button_button_up() -> void:
	global.som_click()
	emit_signal("fechar")
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
