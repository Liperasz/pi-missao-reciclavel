extends Node2D

@onready var recyble_bin_container: StaticBody2D = get_node("Recycle_bin")
@onready var trash_container: Node2D = get_node("Trash")
@onready var background: TextureRect = get_node("Background")
@onready var label_vida: Label = get_node("LabelVida")

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

@onready var trash_quant: int
@onready var recycle_bin_quant: int
var destroyed_trash = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_scenario()
	choose_trash_types()
	create_recycle_bins()
	create_trash()
	atualizar_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	atualizar_label()


func choose_scenario() -> void:
	scenario = scenarios.pick_random()
	var path = "res://assets/scenarios/%s.png" % scenario
	background.texture = load(path)

func atualizar_label():
	label_vida.text =  "VIDA: " + str("%02d" % [global.qtd_vida])
	if global.qtd_vida <= 0:
		global.qtd_vida = global.vidas
		get_tree().reload_current_scene()
	
func choose_trash_types() -> void:
	types_in_level = trash_types
	types_in_level.shuffle()
	
	if global.player_level == 1:
		recycle_bin_quant = 2
		trash_quant =3
	
	elif global.player_level == 2:
		recycle_bin_quant = 3
		trash_quant =5
		
	elif global.player_level == 3:
		recycle_bin_quant = 4
		trash_quant =7
	else:
		recycle_bin_quant = 4
		trash_quant =10
	
	
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
		return
	
	var random_type = types_in_level.pick_random()
	var trash = trash_scene.instantiate()
	trash.type = random_type
	trash.scenario = scenario
	trash.position = Vector2(195, 800)
	trash_container.add_child(trash)
	
	trash.connect("is_on_right_bin", Callable(self, "on_trash_dropped"))

func on_trash_dropped(trash):
	destroyed_trash += 1
	trash.queue_free()
	
	if destroyed_trash >= trash_quant:
		print("Acabou a fase")
		
		#apenas teste
		global.player_level += 1
		get_tree().reload_current_scene()
		
		
		return
		
	else:
		create_trash()
