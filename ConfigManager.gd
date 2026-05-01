extends Node

const SAVE_PATH = "user://settings.cfg"

func _ready():
	# Ici, on appelle directement la fonction sans mettre "ConfigManager." devant
	load_language()

func save_language(lang_code: String):
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("settings", "language", lang_code)
	config.save(SAVE_PATH)

func load_language():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err == OK:
		var lang = config.get_value("settings", "language", "fr")
		TranslationServer.set_locale(lang)
		return lang
	
	# Si le fichier n'existe pas, on force le français par défaut
	TranslationServer.set_locale("fr")
	return "fr"
