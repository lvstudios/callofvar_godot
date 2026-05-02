extends Panel

@onready var start_y = position.y

func _ready():
	# Connecte les signaux automatiquement par code pour gagner du temps
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)


func _on_hover():
	create_tween().tween_property(self, "position:y", start_y - 10, 0.2).set_trans(Tween.TRANS_BACK)

func _on_exit():
	create_tween().tween_property(self, "position:y", start_y, 0.2)




func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().change_scene_to_file("res://menues/reglages_du_jeu.tscn")
