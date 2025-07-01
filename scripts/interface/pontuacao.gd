extends Node2D

signal fechar_tela_pontuacao

@onready var labelPontuacao : Label = get_node("LabelPontuacao")
var score_scene = preload("res://scenes/interface/score_screen.tscn")
var nome_fase: String = ""

# Calcula a pontuação com base em acertos e erros
func calcular_pontuacao():
	global.pontos =  max(0, global.acertos_pontuacao * 10 - global.erros_pontuacao * 5)

func atualizar_label():
	labelPontuacao.text = "Sua Pontuação foi de: " + str(global.pontos) + " Pontos!"
	
# Calcula o número de estrelas com base nos pontos
# acertos maior que 80 são 3 estrelas
# acertos maior que 50 são 2 estrelas
# acertos maior que 5 são 1 estrela
func calcular_estrelas(pontos: int) -> int:
	if pontos >= 80:
		global.estrelas = 3
	elif pontos >= 50:
		global.estrelas = 2
	elif pontos > 5:
		global.estrelas = 1
	else:
		global.estrelas = 0
	return global.estrelas
	
# Estas funçães para quando a fase terminar
func finalizar_fase():
	calcular_pontuacao()
	atualizar_label()
	global.estrelas = calcular_estrelas(global.pontos)
	print("estrelas antes ", global.estrelas)
	global.estrelas *= global.multiplicador
	print("estrelas depois ", global.estrelas)
	nome_fase = "Fase " + str(global.player_level) 
	global.atualizar_fase(nome_fase, global.estrelas)
	global.multiplicador = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finalizar_fase()
	
func _on_button_button_up() -> void:
	emit_signal("fechar_tela_pontuacao")
	queue_free()
	
