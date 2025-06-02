extends Node2D

@onready var sprite: Sprite2D = get_node("Texture")

signal is_on_right_bin(trash)

var type = ""
var scenario = ""

var draggable = false
var is_inside_dropable = false

var body_ref
var offset: Vector2
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
					emit_signal("is_on_right_bin", self)
					
				else:
					print("Lixeira Errada")
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
		scale = Vector2(1,1)
