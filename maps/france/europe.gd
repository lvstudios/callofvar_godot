extends Node2D

@onready var bg := Sprite2D.new()

@export var bg_scale: float = 3.0
@export var texture_path: String = "res://Nouveau dossier/europe.svg" # préfère PNG si SVG bug

func _ready():
	# Charger texture
	var tex = load(texture_path)
	
	if tex == null:
		print("ERREUR: texture introuvable")
		return
	
	bg.texture = tex
	
	# Ajouter à la scène
	add_child(bg)
	
	# Position + centrage
	bg.position = Vector2.ZERO
	bg.centered = true
	
	# Taille
	bg.scale = Vector2.ONE * bg_scale
	
	# Mettre derrière tout
	bg.z_index = -100
	
	print("Fond chargé ✔")
