extends StaticBody2D

var type = ""

@onready var sprite: Sprite2D = get_node("Texture")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_sprite() -> void:
	var path = "res://assets/recycle_bin/%s.png" % type.to_upper()
	sprite.texture = load(path)
