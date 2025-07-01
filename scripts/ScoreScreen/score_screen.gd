extends Node2D

signal fechar

func _ready():

	# Atualiza os elementos da tela
	$LabelPontuacao.text = "Pontuação: " + str(global.pontos)

#mensagem conforme seu desenvolvimento
	if global.estrelas == 3:
		$LabelFeedback.text = "Perfeito!"
	elif global.estrelas == 2:
		$LabelFeedback.text = "Muito bom!"
	elif global.estrelas == 1:
		$LabelFeedback.text = "Você conseguiu!"
	else:
		$LabelFeedback.text = "Tente novamente"

	# Texto do botão (LabelButton está dentro do TextureButton)
	if global.estrelas >= 1:
		$TextureButton/LabelButton.text = "Próxima fase"
		global.player_level += 1
	else:
		$TextureButton/LabelButton.text = "Repetir fase"


func _on_texture_button_button_up() -> void:
	emit_signal("fechar")
	queue_free()
