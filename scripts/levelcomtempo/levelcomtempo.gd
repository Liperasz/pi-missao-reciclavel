extends Node2D

@onready var recyble_bin_container: StaticBody2D = get_node("Recycle_bin")
@onready var trash_container: Node2D = get_node("Trash")
@onready var background: TextureRect = get_node("Background")
@onready var label_tempo: Label = get_node("LabelTempo")
@onready var cronometro: Timer = get_node("%Timer_do_jogo")

var tempo_em_segundos: int = 60

var scenarios = [
	"biblioteca",
	"cidade",
	"construcao",
	"deserto",
	"fazenda",
	#falta 3 cenários que não consegui carregar no godot
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
	global.som_Entrada()
	choose_scenario()
	choose_trash_types()
	create_recycle_bins()
	create_trash()	
	cronometro.connect("timeout", Callable(self, "_on_cronometro_timeout"))
	atualizar_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_cronometro_timeout():
	tempo_em_segundos -= 1
	atualizar_label()
	
func atualizar_label():
	var min = tempo_em_segundos / 60
	var seg = tempo_em_segundos % 60
	label_tempo.text = "TEMPO: " + str("%02d:%02d" % [min, seg])
	if tempo_em_segundos <= 0:
		cronometro.stop()
	
func choose_scenario() -> void:
	scenario = scenarios.pick_random()
	var path = "res://assets/scenarios/%s.png" % scenario
	background.texture = load(path)


func choose_trash_types() -> void:
	types_in_level = trash_types
	types_in_level.shuffle()
	
	if global.player_level == 1:
		recycle_bin_quant = 2
	
	elif global.player_level == 2:
		recycle_bin_quant = 3
		
	elif global.player_level == 3:
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

func create_trash():
	var random_type = types_in_level.pick_random()
	var trash = trash_scene.instantiate()
	trash.type = random_type
	trash.scenario = scenario
	trash.position = Vector2(195, 800)
	trash_container.add_child(trash)
	
	trash.connect("is_on_right_bin", Callable(self, "on_trash_dropped"))

func on_trash_dropped(trash):
	tocar_som(trash.type)
	trash.queue_free()
	
	if tempo_em_segundos == 0:	
		finalizou_a_fase()

	else:
		create_trash()

func zerar_variaveis_globais():
	global.acertos_pontuacao = 0
	global.erros_pontuacao = 0
	global.estrelas = 0
	global.pontos = 0

func finalizou_a_fase():
	print("Acabou a fase")
	print("Acertos", global.acertos_pontuacao)
	print("Erros", global.erros_pontuacao)
	var pontuacao = pontuacao_scene.instantiate()
	add_child(pontuacao)
	await pontuacao.fechar_tela_pontuacao
	var score = score_scene.instantiate()
	add_child(score)
	await score.fechar
	zerar_variaveis_globais()
	if global.missao_diaria == true:
		global.missao_diaria = false
		get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")
	else:
		get_tree().reload_current_scene()	
	
func limpar_lixo_poder():
	for child in trash_container.get_children():
		print("Filho encontrado:", child.name, "Tipo:", child)
	if trash_container.get_child_count() > 0:
		for child in trash_container.get_children():
			if child is Trash:
				print("Limpou um lixo:", child.name)
				child.queue_free()
				global.acertos_pontuacao += 1
				break
	if tempo_em_segundos != 0:
		create_trash()
	
func super_ima_poder():
	if trash_container.get_child_count() > 0:
		for child in trash_container.get_children():
			if child is Trash and child.type == "metal":
				print("Limpou um lixo:", child.name)
				child.queue_free()
				global.acertos_pontuacao += 1
				if tempo_em_segundos != 0:
					create_trash()
				break
	
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
