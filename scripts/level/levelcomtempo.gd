extends Node2D

@onready var recyble_bin_container: StaticBody2D = get_node("Recycle_bin")
@onready var trash_container: Node2D = get_node("Trash")
@onready var background: TextureRect = get_node("Background")
@onready var label_tempo: Label = get_node("LabelTempo")
@onready var cronometro: Timer = get_node("%Timer_do_jogo")

var configuracoes_scene = preload("res://scenes/interface/configuracoes.tscn")

var tempo_em_segundos: int = 60
var tempo_inicial: int
var tempo_medio_por_lixo: float = 2.0


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

@onready var recycle_bin_quant: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.is_on_match = true
	global.super_ima_ativo = false
	tempo_inicial = tempo_em_segundos # Define o tempo inicial aqui
	choose_scenario()
	choose_trash_types()
	create_recycle_bins()
	create_trash()
	cronometro.connect("timeout", Callable(self, "_on_cronometro_timeout"))
	atualizar_label()

func _on_cronometro_timeout():
	if tempo_em_segundos > 0:
		tempo_em_segundos -= 1
		atualizar_label()
	
	if tempo_em_segundos <= 0:
		cronometro.stop()
		# Limpa qualquer lixo restante antes de finalizar
		for child in trash_container.get_children():
			child.queue_free()
		finalizou_a_fase()
	
func atualizar_label():
	var min = tempo_em_segundos / 60
	var seg = tempo_em_segundos % 60
	label_tempo.text = "TEMPO: " + str("%02d:%02d" % [min, seg])


func choose_scenario() -> void:
	scenario = scenarios.pick_random()
	var path = "res://assets/scenarios/%s.png" % scenario
	background.texture = load(path)


func choose_trash_types() -> void:
	types_in_level = trash_types
	types_in_level.shuffle()
	
	if global.current_level == 1:
		recycle_bin_quant = 2
	elif global.current_level == 2:
		recycle_bin_quant = 3
	elif global.current_level == 3:
		recycle_bin_quant = 4
	else:
		recycle_bin_quant = 4
	
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

func _attract_metal_trash(trash_node: Trash):
	if not (global.super_ima_ativo and trash_node.type == "metal"):
		return

	trash_node.interacao_bloqueada = true
	
	var metal_bin = null
	for bin in recyble_bin_container.get_children():
		if "type" in bin and bin.type == "METAL":
			metal_bin = bin
			break
	
	if metal_bin:
		var tween = get_tree().create_tween()
		tween.tween_property(trash_node, "global_position", metal_bin.global_position, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
		tween.tween_callback(func(): on_trash_dropped(trash_node, true))
	else:
		on_trash_dropped(trash_node, true)

func create_trash():
	# Impede a criação de novos lixos se o tempo acabou.
	if tempo_em_segundos <= 0:
		return
		
	var random_type = types_in_level.pick_random()
	var trash = trash_scene.instantiate()
	trash.type = random_type
	trash.scenario = scenario
	trash.position = Vector2(195, 800)
	trash_container.add_child(trash)
	
	trash.connect("is_on_right_bin", Callable(self, "on_trash_dropped"))
	
	# Chama a função auxiliar para verificar se este novo lixo deve ser atraído.
	_attract_metal_trash(trash)

func on_trash_dropped(trash, coleta_automatica = false):
	if coleta_automatica:
		global.acertos_pontuacao += 1
		
	tocar_som(trash.type)
	
	if trash and is_instance_valid(trash) and not trash.is_queued_for_deletion():
		trash.queue_free()
	
	if tempo_em_segundos > 0:
		create_trash()

func zerar_variaveis_globais():
	global.acertos_pontuacao = 0
	global.erros_pontuacao = 0
	global.estrelas = 0
	global.pontos = 0
	global.super_ima_ativo = false

func finalizou_a_fase():
	print("Acabou a fase")
	print("Acertos", global.acertos_pontuacao)
	print("Erros", global.erros_pontuacao)
	
	var pontuacao_maxima_esperada = (tempo_inicial / tempo_medio_por_lixo) * 10
	if pontuacao_maxima_esperada <= 0:
		pontuacao_maxima_esperada = 10
	
	var pontuacao = pontuacao_scene.instantiate()
	pontuacao.pontuacao_maxima = pontuacao_maxima_esperada

	add_child(pontuacao)
	await pontuacao.fechar_tela_pontuacao
	
	var score = score_scene.instantiate()
	add_child(score)
	
	var acao_escolhida = await score.fechar
	var estrelas_ganhas = global.estrelas
	zerar_variaveis_globais()
	global.is_on_match = false
	if global.missao_diaria == true:
		global.missao_diaria = false
		get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
	else:
		if acao_escolhida == "menu":
			get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
		else:
			if estrelas_ganhas >= 1:
				global.current_level += 1
			if global.current_level % 2 == 0:
				get_tree().change_scene_to_file("res://scenes/level/levelcomtempo.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/level/level_com_vida.tscn")
	
func limpar_lixo_poder():
	if trash_container.get_child_count() > 0:
		var child = trash_container.get_child(0)
		if child is Trash:
			print("Limpou um lixo:", child.name)
			on_trash_dropped(child, true)
				
func super_ima_poder():
	global.super_ima_ativo = true
	print("Super Imã ATIVADO!")
	
	if trash_container.get_child_count() > 0:
		var current_trash = trash_container.get_child(0)
		if current_trash is Trash:
			_attract_metal_trash(current_trash)
	
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
