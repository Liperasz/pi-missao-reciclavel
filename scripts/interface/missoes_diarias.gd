extends Node2D

# Define o caminho do arquivo de configuração onde a data será salva
const CONFIG_FILE_PATH = "user://daily_missions.cfg"
var config = ConfigFile.new()

# Variável para armazenar a data da última execução da missão (formato YYYY-MM-DD)
var last_mission_date: String = ""

func _ready() -> void:
	load_last_mission_date()
	update_mission_buttons_state() # Atualiza o estado dos botões ao carregar a cena

func _process(delta: float) -> void:
	pass

# Carrega a data da última missão salva no arquivo
func load_last_mission_date():
	var error = config.load(CONFIG_FILE_PATH)
	if error != OK:
		print("Erro ao carregar arquivo de configuração de missões diárias: ", error)
		# Se o arquivo não existir ou houver erro, assume que nunca foi jogado hoje
		last_mission_date = ""
	else:
		if config.has_section_key("DailyMission", "last_played_date"):
			last_mission_date = config.get_value("DailyMission", "last_played_date")
			print("Última missão jogada em: ", last_mission_date)
		else:
			last_mission_date = ""

# Salva a data atual como a última vez que a missão foi jogada
func save_current_mission_date():
	var current_datetime = Time.get_datetime_dict_from_system()
	# Formata a data para YYYY-MM-DD
	last_mission_date = "%04d-%02d-%02d" % [current_datetime.year, current_datetime.month, current_datetime.day]
	config.set_value("DailyMission", "last_played_date", last_mission_date)
	var error = config.save(CONFIG_FILE_PATH)
	if error != OK:
		print("Erro ao salvar arquivo de configuração de missões diárias: ", error)
	else:
		print("Data da missão salva: ", last_mission_date)

### Funções de Verificação e Atualização
# Verifica se a missão já foi jogada hoje
func has_mission_been_played_today() -> bool:
	var current_datetime = Time.get_datetime_dict_from_system()
	var today_date = "%04d-%02d-%02d" % [current_datetime.year, current_datetime.month, current_datetime.day]

	return last_mission_date == today_date

# Atualiza o estado dos botões de missão (habilitar/desabilitar)
func update_mission_buttons_state():
	var mission_played = has_mission_been_played_today()

	var missao_1_button = get_node("missao1") 
	var missao_2_button = get_node("missao2") 
	var missao_3_button = get_node("missao3") 

	if missao_1_button:
		missao_1_button.disabled = mission_played
	if missao_2_button:
		missao_2_button.disabled = mission_played
	if missao_3_button:
		missao_3_button.disabled = mission_played

	# Opcional: mostrar uma mensagem para o jogador se as missões estiverem desabilitadas
	if mission_played:
		print("As missões diárias já foram completadas hoje. Volte amanhã!")

func _on_missao_1_button_up() -> void:
	global.som_click()
	if not has_mission_been_played_today():
		global.player_level = 1
		global.multiplicador = 2
		global.missao_diaria = true
		aleatorio()
		save_current_mission_date() # Salva a data após a missão ser jogada
		update_mission_buttons_state() # Desabilita os botões após jogar
	else:
		print("Missão 1: Já jogou hoje!")


func _on_missao_2_button_up() -> void:
	global.som_click()
	if not has_mission_been_played_today():
		global.player_level = 2
		global.multiplicador = 2.5
		global.missao_diaria = true
		aleatorio()
		save_current_mission_date()
		update_mission_buttons_state()
	else:
		print("Missão 2: Já jogou hoje!")


func _on_missao_3_button_up() -> void:
	global.som_click()
	if not has_mission_been_played_today():
		global.player_level = 4
		global.multiplicador = 3
		global.missao_diaria = true
		aleatorio()
		save_current_mission_date()
		update_mission_buttons_state()
	else:
		print("Missão 3: Já jogou hoje!")


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/tela_inicial.tscn")

func aleatorio():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var numero_aleatorio = rng.randi_range(0, 1)
	if numero_aleatorio == 1:
		get_tree().change_scene_to_file("res://scenes/levelcomtempo/levelcomtempo.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level_com_vida/level_com_vida.tscn")
