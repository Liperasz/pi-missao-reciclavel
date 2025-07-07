extends Node
# ============================================================================
# 1. ESTADO DO JOGO E CONFIGURAÇÕES
# ============================================================================

# Define se o jogador está atualmente em uma partida.
var is_on_match = false

# Define se o modo de jogo "Especial" (com vida/tempo) está ativo.
var modo_especial = false

# Define o nível que o jogador está jogando no momento.
var current_level = 1

# Flags de estado para partidas especiais.
var missao_diaria = false
var super_ima_ativo = false

# Configurações de áudio
var music_player: AudioStreamPlayer
var musica_ativa = true
var efeitos_sonoros_ativos = true
var abriu_jogo = true

# Configurações do jogador.
var volume = 0

# Variáveis de controle de input (não usadas no momento, mas mantidas).
var item_selecionado: int = 0
var is_dragging = false


# ============================================================================
# 2. DADOS DE PROGRESSO DO JOGADOR (PERSISTENTE)
# ============================================================================

const SAVE_FILE_PATH = "user://progresso_jogador.save"

var progresso_padrao = { "max_level": 1, "fases_completas": {} }
var progresso_especial = { "max_level": 1, "fases_completas": {} }

var saldo_estrelas = 0
var poderes = {
	1: {"nome": "add_vida", "quantidade": 1},
	2: {"nome": "limpador_rapido", "quantidade": 1},
	3: {"nome": "dupla_pontuacao", "quantidade": 0},
	4: {"nome": "pausa_temporal", "quantidade": 1},
	5: {"nome": "super_ima", "quantidade": 0},
}


# ============================================================================
# 3. DADOS DA PARTIDA ATUAL (TEMPORÁRIO)
# ============================================================================

var vidas : int = 5
var qtd_vida : int = vidas
var pontos = 0
var estrelas = 0
var acertos_pontuacao = 0
var erros_pontuacao = 0
var multiplicador = 1
var erros = 0
var erros_consecutivos = 0


# ============================================================================
# 4. FUNÇÕES PRINCIPAIS E DE LÓGICA
# ============================================================================

func _ready():
	music_player = AudioStreamPlayer.new()
	 
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"
		
	# Adiciona o player como filho da raiz da árvore de cenas.
	# Isso garante que ele persista durante todo o jogo, mesmo trocando de cena.
	get_tree().get_root().add_child.call_deferred(music_player)
	
	carregar_progresso()


func atualizar_fase(fase_nome: String, estrelas_conquistadas: int, pontos_conquistados: int) -> void:
	var progresso_alvo = progresso_especial if modo_especial else progresso_padrao
	var dados_antigos = progresso_alvo.fases_completas.get(fase_nome, {"estrelas": 0, "pontos": 0})
	var estrelas_antigas = dados_antigos["estrelas"]
	var pontuacao_antiga = dados_antigos["pontos"]
	var diferenca_estrelas = max(0, estrelas_conquistadas - estrelas_antigas)
	saldo_estrelas += diferenca_estrelas
	progresso_alvo.fases_completas[fase_nome] = {
		"estrelas": max(estrelas_antigas, estrelas_conquistadas),
		"pontos": max(pontuacao_antiga, pontos_conquistados)
	}
	salvar_progresso()


# ============================================================================
# 5. SISTEMA DE SAVE E LOAD
# ============================================================================

func salvar_progresso():
	var dados_para_salvar = {
		"progresso_padrao": progresso_padrao,
		"progresso_especial": progresso_especial,
		"saldo_estrelas": saldo_estrelas,
		"poderes": poderes,
		# --- SALVANDO AS NOVAS CONFIGURAÇÕES ---
		"musica_ativa": musica_ativa,
		"efeitos_sonoros_ativos": efeitos_sonoros_ativos
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(dados_para_salvar)
		file.close()

func carregar_progresso():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var dados_carregados = file.get_var()
			progresso_padrao = dados_carregados.get("progresso_padrao", { "max_level": 1, "fases_completas": {} })
			progresso_especial = dados_carregados.get("progresso_especial", { "max_level": 1, "fases_completas": {} })
			saldo_estrelas = dados_carregados.get("saldo_estrelas", 0)
			poderes = dados_carregados.get("poderes", poderes)
			# --- CARREGANDO AS NOVAS CONFIGURAÇÕES ---
			musica_ativa = dados_carregados.get("musica_ativa", true)
			efeitos_sonoros_ativos = dados_carregados.get("efeitos_sonoros_ativos", true)
			
			# Aplica o estado carregado aos buses de áudio
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not musica_ativa)
			AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), not efeitos_sonoros_ativos)
			
			file.close()


# Função de utilidade para limpar o save durante o desenvolvimento.
func deletar_progresso_antigo():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		print("Arquivo de save antigo encontrado. Deletando...")
		var dir = DirAccess.open("user://")
		dir.remove(SAVE_FILE_PATH.get_file())
		print("Arquivo de save deletado.")


# ============================================================================
# 6. SISTEMA DE SOM
# Funções para tocar os efeitos sonoros do jogo.
# ============================================================================

func tocar_som(som):
	var tocar = AudioStreamPlayer.new()
	tocar.stream = som
	tocar.bus = "SFX"
	add_child(tocar) 
	tocar.play()
	tocar.connect("finished", Callable(tocar, "queue_free"))

func som_lixeira_correta():   
	var som = load("res://assets/song/LixeiraCorreta.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")
		
func som_lixeira_errada():   
	var som = load("res://assets/song/LixeiraErrada.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")
		
func som_click():   
	var som = load("res://assets/song/click.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Entrada(): 
	var som = load("res://assets/song/Entrada.wav")
	if som:
		var player_entrada = AudioStreamPlayer.new()
		player_entrada.stream = som
		player_entrada.bus = "SFX"
		add_child(player_entrada) # Adiciona o player de SFX como filho do singleton
		player_entrada.play()
		
		player_entrada.connect("finished", func():
			tocar_trilha_sonora()
			player_entrada.queue_free()
		)
	else:
		push_error("Arquivo de som 'Entrada.wav' não encontrado!")
		
func tocar_trilha_sonora():
	var trilha = load("res://assets/song/TrilhaSonora.mp3")
	if trilha:
		trilha.loop = true
		music_player.stream = trilha
		music_player.play()
	else:
		push_error("Arquivo da trilha sonora não encontrado")

func som_Game_over():   
	var som = load("res://assets/song/GameOver.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Poder_Vida():   
	var som = load("res://assets/song/PoderComprarVida.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Poder_Dobrar_Ganho():   
	var som = load("res://assets/song/PoderDobrarGanho.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Poder_Ima():   
	var som = load("res://assets/song/PoderImã.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")
		
func som_Poder_Limpador():   
	var som = load("res://assets/song/PoderLimpador.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Poder_Tempo():   
	var som = load("res://assets/song/PoderTempo.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")

func som_Vitoria():   
	var som = load("res://assets/song/Vitoria.wav")
	if som: tocar_som(som)
	else: push_error("Arquivo de som não encontrado!")
