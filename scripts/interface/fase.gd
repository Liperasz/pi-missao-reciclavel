extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogar_button_up() -> void:
	
	var scenes = [
			"res://scenes/level/level.tscn",
			"res://scenes/levelcomtempo/levelcomtempo.tscn"
		]

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var random_index = rng.randi_range(0, scenes.size() - 1)
	var selected_scene = scenes[random_index]

	get_tree().change_scene_to_file(selected_scene)


func _on_voltar_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/selecionar_fase.tscn")
