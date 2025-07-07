extends Node2D
var item_selecionado: int = 0

var is_dragging = false

#level do jogador
var current_level = 1
var max_level = 1

var missao_diaria = false
var vidas : int = 5
var qtd_vida : int = vidas

var poderes = {
	1: {"nome": "add_vida", "quantidade": 2},
	2: {"nome": "limpador_rapido", "quantidade": 2},
	3: {"nome": "dupla_pontuacao", "quantidade": 2},
	4: {"nome": "pausa_temporal", "quantidade": 2},
	5: {"nome": "super_ima", "quantidade": 2},
}
# Variaveis para dicas
var erros = 0
var erros_consecutivos = 0

# Variaveis para controle de pontuacao
var erros_pontuacao = 0
var acertos_pontuacao = 0
var pontos = 0
var estrelas = 0
var multiplicador = 1
#sistema de pontuação inicio
#variaves inicializadas
var fases_completas = {}  # funcionará no esquema: {"Fase 1": {"estrelas": 3, "pontos": 150}}
var saldo_estrelas = 100

#variaveis para escolher modo de jogo:
var modo_especial = false

#variaveis de configuração:
var volume = 0
# Caminho para salvar o progresso
const SAVE_FILE_PATH = "user://progresso_jogador.save"

func deletar_progresso_antigo():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		print("Arquivo de save antigo encontrado. Deletando...")
		var dir = DirAccess.open("user://")
		dir.remove(SAVE_FILE_PATH.get_file())
		print("Arquivo de save deletado.")

func _ready():
	#deletar_progresso_antigo()
	carregar_progresso()

# ela e chamada quando o jogador termina uma fase
func atualizar_fase(fase_nome: String, estrelas_conquistadas: int, pontos_conquistados: int) -> void:

	var dados_antigos = fases_completas.get(fase_nome, {"estrelas": 0, "pontos": 0})
	var estrelas_antigas = dados_antigos["estrelas"]
	var pontuacao_antiga = dados_antigos["pontos"]

	# Calcula a diferença de estrelas para adicionar ao saldo do jogador.
	var diferenca_estrelas = max(0, estrelas_conquistadas - estrelas_antigas)
	if diferenca_estrelas > 0:
		saldo_estrelas += diferenca_estrelas

	# Atualiza os recordes para os maiores valores já obtidos.
	var novo_recorde_estrelas = max(estrelas_antigas, estrelas_conquistadas)
	var novo_recorde_pontos = max(pontuacao_antiga, pontos_conquistados)

	# Salva o novo "pacote" de dados no dicionário.
	fases_completas[fase_nome] = {
		"estrelas": novo_recorde_estrelas,
		"pontos": novo_recorde_pontos
	}
	
	salvar_progresso()

# salva os dados 
func salvar_progresso():
	var dados = {
		"fases_completas": fases_completas,
		"saldo_estrelas": saldo_estrelas,
		"max_level": max_level
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(dados)
		file.close()

func carregar_progresso():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var dados = file.get_var()
			fases_completas = dados.get("fases_completas", {})
			saldo_estrelas = dados.get("saldo_estrelas", 0)
			max_level = dados.get("max_level", 1)
			file.close()

func som_lixeira_correta():	
	var som = load("res://assets/song/LixeiraCorreta.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)
		
func som_lixeira_errada():	
	var som = load("res://assets/song/LixeiraErrada.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)
		
func som_click():	
	var som = load("res://assets/song/click.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)		

func som_Entrada():	
	var som = load("res://assets/song/Entrada.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)		

func som_Game_over():	
	var som = load("res://assets/song/GameOver.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)		

func som_Poder_Vida():	
	var som = load("res://assets/song/PoderComprarVida.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)		

func som_Poder_Dobrar_Ganho():	
	var som = load("res://assets/song/PoderDobrarGanho.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)	

func som_Poder_Ima():	
	var som = load("res://assets/song/PoderImã.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)	
		
func som_Poder_Limpador():	
	var som = load("res://assets/song/PoderLimpador.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)	

func som_Poder_Tempo():	
	var som = load("res://assets/song/PoderTempo.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)	

func som_Vitoria():	
	var som = load("res://assets/song/Vitoria.wav")
	if som == null:
		push_error("Arquivo não encontrado! ")
		return
	else:
		tocar_som(som)			
					
func tocar_som(som):
	var tocar = AudioStreamPlayer.new()
	tocar.stream = som
	add_child(tocar) 
	tocar.play()
	tocar.connect("finished", Callable(tocar, "queue_free"))
	
