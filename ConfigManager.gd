extends Node

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

func _ready():
	# On charge le fichier une seule fois au lancement
	var err = config.load(SAVE_PATH)
	
	# On applique direct les réglages sauvegardés
	load_language()
	load_settings()

# --- PARTIE LANGUE ---

func save_language(lang_code: String):
	# On utilise la variable 'config' globale au lieu d'en créer une nouvelle
	config.set_value("settings", "language", lang_code)
	config.save(SAVE_PATH)

func load_language():
	# Pas besoin de re-charger le fichier, c'est fait dans _ready
	var lang = config.get_value("settings", "language", "fr")
	TranslationServer.set_locale(lang)

# --- PARTIE VIDÉO ---

func load_settings() -> void:
	# Pas besoin de re-charger le fichier ici non plus
	var mode = config.get_value("video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_mode(mode)

func save_video_setting(key: String, value: Variant) -> void:
	config.set_value("video", key, value)
	var err = config.save(SAVE_PATH)
	if err != OK:
		print("Erreur lors de la sauvegarde : ", err)
