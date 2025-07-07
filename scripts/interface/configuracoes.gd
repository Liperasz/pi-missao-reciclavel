extends Node2D

@onready var voltar_button = $voltar
@onready var menu_button = $menu
@onready var musica_button = $musica
@onready var efeitos_sonoros_button = $efeitos_sonoros
@onready var fundo = $fundo

var background_fase = load("res://assets/interface/configuracao_fase.png")
var background_menu = load("res://assets/interface/configuracao_menu.png")

# Índice do bus de áudio para os Efeitos Sonoros (SFX).
var SFX_BUS_INDEX = AudioServer.get_bus_index("SFX")
# var MUSIC_BUS_INDEX = AudioServer.get_bus_index("Music")


func _ready() -> void:	
	# Lógica para mostrar/esconder o botão "Voltar ao Jogo".
	if global.is_on_match:
		fundo.texture = background_fase
		voltar_button.visible = true
		voltar_button.disabled = false
	else:
		fundo.texture = background_menu
		voltar_button.visible = false
		voltar_button.disabled = true
		
	atualizar_texto_botoes_audio()
	
	
func atualizar_texto_botoes_audio():
	# Atualiza o texto do botão de música.
	if global.musica_ativa:
		musica_button.text = "DESATIVAR MÚSICA"
	else:
		musica_button.text = "ATIVAR MÚSICA"
		
	# Atualiza o texto do botão de efeitos sonoros.
	if global.efeitos_sonoros_ativos:
		efeitos_sonoros_button.text = "DESATIVAR SONS"
	else:
		efeitos_sonoros_button.text = "ATIVAR SONS"


func _on_musica_button_up() -> void:
	global.som_click()
	# Inverte o estado da música.
	global.musica_ativa = not global.musica_ativa
	
	# AudioServer.set_bus_mute(MUSIC_BUS_INDEX, not global.musica_ativa)
	
	atualizar_texto_botoes_audio()
	global.salvar_progresso()


func _on_efeitos_sonoros_button_up() -> void:
	global.som_click()
	global.efeitos_sonoros_ativos = not global.efeitos_sonoros_ativos
	
	# Silencia ou dessilencia o bus de SFX.
	AudioServer.set_bus_mute(SFX_BUS_INDEX, not global.efeitos_sonoros_ativos)
	
	atualizar_texto_botoes_audio()
	global.salvar_progresso()


func _on_voltar_button_up() -> void:
	global.som_click()
	# Despausa o jogo e remove a tela de configurações.
	get_tree().paused = false
	queue_free()

func _on_menu_button_up() -> void:
	global.som_click()
	# Despausa o jogo antes de mudar de cena.
	get_tree().paused = false
	
	if global.is_on_match:
		# Se estava em uma partida, volta para a seleção de fase.
		get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
		global.is_on_match = false
	else:
		# Se estava no menu, volta para a tela inicial.
		get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")

# Funções de controle de volume geral (Master).
func _on_aumentar_button_up() -> void:
	if global.volume < 100:
		global.volume += 3
		alterar_volume(global.volume)
		global.som_click()
		
func _on_diminuir_button_up() -> void:
	if global.volume > 0:
		global.volume -= 3
		alterar_volume(global.volume)
		global.som_click()
	
func alterar_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
