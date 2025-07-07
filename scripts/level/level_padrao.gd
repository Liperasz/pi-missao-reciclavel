extends Node2D

@onready var recyble_bin_container: StaticBody2D = get_node("Recycle_bin")
@onready var trash_container: Node2D = get_node("Trash")
@onready var background: TextureRect = get_node("Background")

var configuracoes_scene = preload("res://scenes/interface/configuracoes.tscn")

var scenarios = [
	"biblioteca",
	"cidade",
	"construcao",
	"deserto",
	"fazenda",
	"parque_diversao",
	"praia"
]

var trash_types = [
	"metal",
	"organico",
	"papel",
	"plastico",
	"vidro"
]

var scenario = ""
var types_in_level = []

var recycle_bin_scene = preload("res://scenes/recycle_bin/recycle_bin.tscn")
var trash_scene = preload("res://scenes/trash/trash.tscn")
var pontuacao_scene = preload("res://scenes/interface/pontuacao.tscn")
var score_scene = preload("res://scenes/interface/score_screen.tscn")

@onready var trash_quant: int
@onready var recycle_bin_quant: int
var destroyed_trash = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.is_on_match = true
	choose_scenario()
	choose_trash_types()
	create_recycle_bins()
	create_trash()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func choose_scenario() -> void:
	scenario = scenarios.pick_random()
	var path = "res://assets/scenarios/%s.png" % scenario
	background.texture = load(path)

	
func choose_trash_types() -> void:
	types_in_level = trash_types
	types_in_level.shuffle()
	
	if global.current_level == 1:
		recycle_bin_quant = 2
		trash_quant = 3
	
	elif global.current_level == 2:
		recycle_bin_quant = 3
		trash_quant = 5
		
	elif global.current_level == 3:
		recycle_bin_quant = 4
		trash_quant = 7
	else:
		recycle_bin_quant = 4
		trash_quant = 10
	
	
	types_in_level = types_in_level.slice(0, recycle_bin_quant)
	
	
func create_recycle_bins() -> void:
	
	var bin_spacing = 90
	var bin_width = 80
	
	var total_width = (types_in_level.size() - 1) * bin_spacing + bin_width
	
	var start_x = (370 - total_width) / 2 + bin_width / 2
	
	for i in types_in_level.size():
		var type = types_in_level[i].to_upper()
		var recycle_bin = recycle_bin_scene.instantiate()
		recycle_bin.type = type
		
		var x = start_x + i * bin_spacing
		var y = 550
		
		recycle_bin.position = Vector2(x, y)
		recyble_bin_container.add_child(recycle_bin)

func create_trash():
	if destroyed_trash >= trash_quant:
		print("Fase completada")
		finalizou_a_fase()
		return
	
	var random_type = types_in_level.pick_random()
	var trash = trash_scene.instantiate()
	trash.type = random_type
	trash.scenario = scenario
	trash.position = Vector2(195, 800)
	trash_container.add_child(trash)
	
	trash.connect("is_on_right_bin", Callable(self, "on_trash_dropped"))

func on_trash_dropped(trash):
	tocar_som(trash.type)
	destroyed_trash += 1
	trash.queue_free()
	
	# Checa se já coletou todos os lixos necessários
	if destroyed_trash >= trash_quant:	 
		finalizou_a_fase()
	else:
		# Se não, cria o próximo lixo
		create_trash()
		
func zerar_variaveis_globais():
	global.acertos_pontuacao = 0
	global.erros_pontuacao = 0
	global.estrelas = 0
	global.pontos = 0

func finalizou_a_fase():
	print("Acabou a fase", global.current_level)
	print("Acertos", global.acertos_pontuacao)
	print("Erros", global.erros_pontuacao)
	
	var pontuacao = pontuacao_scene.instantiate()
	var pontuacao_maxima = trash_quant * 10
	pontuacao.pontuacao_maxima = pontuacao_maxima
	
	add_child(pontuacao)
	await pontuacao.fechar_tela_pontuacao
	
	var score = score_scene.instantiate()
	add_child(score)
	
	var acao = await score.fechar
	var estrelas_ganhas = global.estrelas
	zerar_variaveis_globais()
	global.is_on_match = false
	if global.missao_diaria == true:
		global.missao_diaria = false
		get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
	else:
		if acao == "menu":
			get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
		else:
			if estrelas_ganhas >= 1:
				global.current_level += 1
			get_tree().reload_current_scene()
		


func tocar_som(random_type):
	var tocar = AudioStreamPlayer.new()
	var audio_path = "res://assets/song/Arrasta_%s.wav" % random_type
	var som = load(audio_path)
	
	if som == null:
		push_error("Pasta não encontrada: " + audio_path)
		return

	tocar.stream = som
	add_child(tocar) 
	tocar.play()
	await tocar.finished
	tocar.queue_free()


func _on_pausar_button_up() -> void:
	# 1. Pausa a árvore de cenas inteira. Timers e _process param.
	get_tree().paused = true
	
	# 2. Cria uma instância da tela de configurações.
	var settings_menu = configuracoes_scene.instantiate()
	settings_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().root.add_child(settings_menu)
