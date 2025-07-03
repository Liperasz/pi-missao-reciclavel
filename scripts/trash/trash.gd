extends Node2D
class_name Trash

@onready var sprite: Sprite2D = get_node("Texture")

signal is_on_right_bin(trash)

var type = ""
var scenario = ""

var draggable = false
var is_inside_dropable = false

var body_ref
var offset: Vector2
var initial_position: Vector2

func _ready() -> void:
	load_sprite()

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			initial_position = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true

		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset

		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()

			if is_inside_dropable:
				if self.type == body_ref.type.to_lower():
					global.erros_consecutivos = 0  # Reset após acerto
					global.acertos_pontuacao += 1
					emit_signal("is_on_right_bin", self)
				else:
					global.erros += 1
					global.erros_consecutivos += 1
					global.erros_pontuacao +=1
					print("Lixeira Errada")
					global.qtd_vida -= 1

					if global.erros_consecutivos >= 2:
						mostrar_dica()
						global.erros_consecutivos = 0  # Reset após dica

					tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)

func load_sprite() -> void:
	var folder_path = "res://assets/trash/%s" % scenario
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		push_error("Pasta não encontrada: " + folder_path)
		return

	dir.list_dir_begin()
	var candidates = []
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.get_basename().ends_with(type):
				candidates.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()

	if candidates.is_empty():
		push_error("Nenhum lixo encontrado para tipo %s no cenário %s" % [type, scenario])
		return

	var random_trash = candidates.pick_random()
	var texture = load(folder_path + "/" + random_trash)

	if texture:
		sprite.texture = texture
	else:
		push_error("Imagem não encontrada: " + folder_path + "/" + random_trash)
	#print("📂 Pasta:", folder_path)
	#print("🔍 Tipo:", type)
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.scale = Vector2(1.05, 1.05)
		body_ref = body

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		body.scale = Vector2(1., 1)
		is_inside_dropable = false

func _on_area_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_mouse_exited() -> void:
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)

func mostrar_dica():
	var dica = "O lixo deve ir na lixeira de " + type.to_upper() + "."

	var label = Label.new()
	label.text = dica
	label.add_theme_font_size_override("font_size", 18)
	label.position = Vector2(50, 50)  
	label.modulate.a = 0

	get_tree().current_scene.add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(3)
	tween.tween_property(label, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(label, "queue_free"))
