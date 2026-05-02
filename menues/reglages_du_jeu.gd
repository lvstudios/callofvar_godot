extends Node2D

# On récupère l'accès à l'OptionButton (vérifie bien le nom du nœud dans ta scène)
@onready var lang_button = $OptionButton 


func _ready() -> void:
	var langue_actuelle = TranslationServer.get_locale()
	$CheckButton.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	# On synchronise l'affichage du bouton au démarrage
	if langue_actuelle.begins_with("en"):
		$OptionButton.selected = 0
	elif langue_actuelle.begins_with("fr"):
		$OptionButton.selected = 1
	elif langue_actuelle.begins_with("de"):
		$OptionButton.selected = 2
	elif langue_actuelle.begins_with("es"):
		$OptionButton.selected = 3
	
	# 2. On pourrait aussi synchroniser ici l'état du CheckButton plein écran si besoin

# --- GESTION DE LA LANGUE ---
# Connecte le signal "item_selected" de ton OptionButton ici
func _on_option_button_item_selected(index: int) -> void:
	var lang = "en"
	
	match index:
		0: lang = "en"
		1: lang = "fr" 
		2: lang = "de" # Allemand
		3: lang = "es" # Espagnol
	
	TranslationServer.set_locale(lang)
	ConfigManager.save_language(lang)

# --- GESTION DU PLEIN ÉCRAN ---

func _on_check_button_pressed() -> void:
	var mode_actuel = DisplayServer.window_get_mode()
	var nouveau_mode
	
	if mode_actuel == DisplayServer.WINDOW_MODE_WINDOWED:
		nouveau_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		nouveau_mode = DisplayServer.WINDOW_MODE_WINDOWED
	
	# 1. On applique le changement immédiatement
	DisplayServer.window_set_mode(nouveau_mode)
	
	# 2. On délègue la sauvegarde au manager
	ConfigManager.save_video_setting("fullscreen", nouveau_mode)

# --- RETOUR AU MENU ---
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menues/menu principal.tscn")
