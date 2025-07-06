extends Node2D

@onready var level_vida = get_node("..")

func _ready() -> void:
	exibe_quantidade_de_poderes()

func _process(delta: float) -> void:
	exibe_quantidade_de_poderes()
	
func exibe_quantidade_de_poderes() -> void:
	$limpador_rapido/Label.text = str(global.poderes[2]["quantidade"])
	$dupla_pontuacao/Label.text = str(global.poderes[3]["quantidade"])
	$add_vida/Label.text = str(global.poderes[1]["quantidade"]) 
	$super_ima/Label.text = str(global.poderes[5]["quantidade"])
	
func _on_limpador_rapido_button_up() -> void:
	if (global.poderes[2]["quantidade"] > 0):
		global.som_Poder_Limpador()
		global.poderes[2]["quantidade"] -= 1
		level_vida.limpar_lixo_poder()

func _on_dupla_pontuacao_button_up() -> void:
	if (global.poderes[3]["quantidade"] > 0):
		global.som_Poder_Dobrar_Ganho()
		global.poderes[3]["quantidade"] -= 1
		global.multiplicador += 1

func _on_super_ima_button_up() -> void:
	if (global.poderes[5]["quantidade"] > 0):
		global.som_Poder_Ima()
		global.poderes[5]["quantidade"] -= 1
		while(level_vida.destroyed_trash <= level_vida.trash_quant):
			level_vida.super_ima_poder()
			await get_tree().create_timer(2.0).timeout

func _on_add_vida_button_up() -> void:
	if (global.poderes[1]["quantidade"] > 0):
		global.som_Poder_Vida()
		global.poderes[1]["quantidade"] -= 1
		global.qtd_vida += 1
