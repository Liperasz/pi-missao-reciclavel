extends Node2D

@onready var pausar = get_node("congela_tempo/Timer")
@onready var timer_principal =  get_node("%Timer_do_jogo")
@onready var level_tempo = get_node("..")

func _ready() -> void:
	exibe_quantidade_de_poderes()

func _process(delta: float) -> void:
	exibe_quantidade_de_poderes()
	
func exibe_quantidade_de_poderes() -> void:
	$limpador_rapido/Label.text = str(global.poderes[2]["quantidade"])
	$dupla_pontuacao/Label.text = str(global.poderes[3]["quantidade"])
	$congela_tempo/Label.text = str(global.poderes[4]["quantidade"]) 
	$super_ima/Label.text = str(global.poderes[5]["quantidade"])
	
func _on_limpador_rapido_button_up() -> void:
	if (global.poderes[2]["quantidade"] > 0):
		global.som_Poder_Limpador()
		global.poderes[2]["quantidade"] -= 1
		level_tempo.limpar_lixo_poder()



func _on_dupla_pontuacao_button_up() -> void:
	if (global.poderes[3]["quantidade"] > 0):
		global.som_Poder_Dobrar_Ganho()
		global.poderes[3]["quantidade"] -= 1
		global.multiplicador += 1

func _on_congela_tempo_button_up() -> void:
	if (global.poderes[4]["quantidade"] > 0):
		global.som_Poder_Tempo()
		global.poderes[4]["quantidade"] -= 1
		if not pausar.is_connected("timeout", Callable(self, "_on_cronometro_timeout")):
			pausar.connect("timeout", Callable(self, "_on_cronometro_timeout"))
		timer_principal.paused = true
		pausar.wait_time = 10
		pausar.one_shot = true
		pausar.start()  
		
func _on_cronometro_timeout():
	timer_principal.paused = false
		
func _on_super_ima_button_up() -> void:
	if (global.poderes[5]["quantidade"] > 0):
		global.som_Poder_Ima()
		global.poderes[5]["quantidade"] -= 1
		while(timer_principal.is_stopped() == false):
			level_tempo.super_ima_poder()
			await get_tree().create_timer(2.0).timeout
