extends Node2D

@onready var item_image = $ItemImage
@onready var item_text = $ItemDescricao

# Mapeia cada ID para imagem e descrição
var itens = {
	1: {"imagem": preload("res://assets/powers/add_vida.png"), "descricao": "Ganha uma vida extra."},
	2: {"imagem": preload("res://assets/powers/limpador_rapido.png"), "descricao": "Permite ao jogador reciclar um item automaticamente."},
	3: {"imagem": preload("res://assets/powers/dupla_pontuacao.png"), "descricao": "Ganha o dobro de estrelas na fase."},
	4: {"imagem": preload("res://assets/powers/pausa_temporal.png"), "descricao": "Congela o tempo por 10 segundos."},
	5: {"imagem": preload("res://assets/powers/super_ima.png"), "descricao": "Atrai os lixos de metal automaticamente durante a fase."},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var item_id = global.item_selecionado
	if itens.has(item_id):
		item_image.texture = itens[item_id]["imagem"]
		item_text.text = itens[item_id]["descricao"]

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_voltar_button_up() -> void:
	global.som_click()
	get_tree().change_scene_to_file("res://scenes/interface/loja.tscn")
