extends Node2D

signal fechar_tela_pontuacao

@onready var labelPontuacao : Label = get_node("LabelPontuacao2")
var score_scene = preload("res://scenes/interface/score_screen.tscn")
var nome_fase: String = ""

@export
var pontuacao_maxima: int = 0

# Calcula a pontuação com base em acertos e erros
func calcular_pontuacao():
	global.pontos =  max(0, global.acertos_pontuacao * 10 - global.erros_pontuacao * 5)

func atualizar_label():
	labelPontuacao.text = str(global.pontos) 
	
# Calcula o número de estrelas com base nos pontos
# acertos maior que 75% são 3 estrelas
# acertos maior que 50% são 2 estrelas
# acertos maior que 25% são 1 estrela
func calcular_estrelas(pontos: int, pontuacao_maxima: int) -> int:
	if pontuacao_maxima == 0: # Segurança para não dividir por zero
		return 0
		
	var porcentagem = float(pontos) / float(pontuacao_maxima)
	
	if porcentagem >= 0.75:
		global.estrelas = 3
	elif porcentagem >= 0.50:
		global.estrelas = 2
	elif porcentagem > 0.25:
		global.estrelas = 1
	else:
		global.estrelas = 0
	return global.estrelas
	
# Estas funçães para quando a fase terminar
func finalizar_fase():
	calcular_pontuacao()
	atualizar_label()
	
	var estrelas_base = calcular_estrelas(global.pontos, pontuacao_maxima)
	global.estrelas = estrelas_base
	nome_fase = "Fase " + str(global.current_level) 
	
	if not global.missao_diaria:
		global.atualizar_fase(nome_fase, estrelas_base, global.pontos)
	
	# 5. Se o poder de dobrar foi usado, adiciona as estrelas bônus DIRETAMENTE ao saldo.
	if global.multiplicador == 2 and not global.missao_diaria:
		print("Poder de Dupla Pontuação ativado! Ganhando %d estrelas bônus." % estrelas_base)
		global.saldo_estrelas += estrelas_base
		# Opcional, mas recomendado: salvar o progresso de novo para garantir que as estrelas bônus não sejam perdidas.
		global.salvar_progresso()
	
	# 6. Lógica da missão diária (adiciona estrelas ganhas diretamente ao saldo).
	if global.missao_diaria:
		global.saldo_estrelas += estrelas_base
		global.salvar_progresso()

	# 7. Reseta o multiplicador para a próxima partida.
	global.multiplicador = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finalizar_fase()
	
func _on_button_button_up() -> void:
	global.som_click()
	emit_signal("fechar_tela_pontuacao")
	queue_free()
	
