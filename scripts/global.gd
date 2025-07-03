extends Node2D
var item_selecionado: int = 0

var is_dragging = false
var player_level = 1

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
var fases_completas = {}  
var saldo_estrelas = 100

# Caminho para salvar o progresso
const SAVE_FILE_PATH = "user://progresso_jogador.save"

func _ready():
# Carrega progresso salvo ao iniciar o jogo
	carregar_progresso()

# ela e chamada quando o jogador termina uma fase
func atualizar_fase(fase_nome: String, estrelas: int) -> void:
#verifica quanta estraelas o jogador ja tinha
	var estrelas_anteriores = fases_completas.get(fase_nome, 0)
# calcula as novas estrelas
	var novas_estrelas = max(estrelas - estrelas_anteriores, 0)
#se conquistou novas estrelas  serao add ao saldo 
	if novas_estrelas > 0:
		saldo_estrelas += novas_estrelas
# atualiza o maior numeros de estrelas ja conseguido
		fases_completas[fase_nome] = max(estrelas, estrelas_anteriores)
		salvar_progresso()

# salva os dados 
func salvar_progresso():
	var dados = {
		"fases_completas": fases_completas,
		"saldo_estrelas": saldo_estrelas
	}

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
# salva o conteudo os dados 
		file.store_var(dados)
# fecha o arquivo
		file.close()

# carregar o progresso salvo
func carregar_progresso():
# verifica se o arquivo existe
	if FileAccess.file_exists(SAVE_FILE_PATH):
# mode de leitura  do arquivo
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var dados = file.get_var()
			fases_completas = dados.get("fases_completas", {})
			saldo_estrelas = dados.get("saldo_estrelas", 0)
			file.close()
