extends Control

func _ready():
	
	var pontos = Pontuacao.calcular_pontuacao()
	var estrelas = Pontuacao.calcular_estrelas(pontos)

	# Atualiza os elementos da tela
	$LabelPontuacao.text = "Pontuação: " + str(pontos)

#mensagem conforme seu desenvolvimento
	if estrelas == 3:
		$LabelFeedback.text = "Perfeito!"
	elif estrelas == 2:
		$LabelFeedback.text = "Muito bom!"
	elif estrelas == 1:
		$LabelFeedback.text = "Você conseguiu!"
	else:
		$LabelFeedback.text = "Tente novamente"

	# Texto do botão (LabelButton está dentro do TextureButton)
	if estrelas >= 1:
		$TextureButton/LabelButton.text = "Próxima fase"
	else:
		$TextureButton/LabelButton.text = "Repetir fase"

#ve se passou de fase ou nao
func _on_TextureButton_pressed():
	if Pontuacao.calcular_estrelas(Pontuacao.calcular_pontuacao()) >= 1:
		
		get_tree().change_scene_to_file("res://scenes/fases/Fase2.tscn")
	else:
		get_tree().reload_current_scene()
