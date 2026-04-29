extends Node2D

# --- CONFIGURATION DE L'ALIGNEMENT (À régler dans l'inspecteur) ---
@export_group("Calage de la Carte")
@export var scale_factor: float = 1950.0  # Diminue cette valeur (ex: 1900) si le bleu est trop grand
@export var vertical_stretch: float = 1.45 # Augmente (ex: 1.5) si la France est encore un peu "aplatie"
@export var map_center_lon: float = 2.45   # Axe horizontal de pivot
@export var map_center_lat: float = 46.5   # Axe vertical de pivot
@export var screen_offset: Vector2 = Vector2(576, 324) # Déplace le bloc bleu (X: droite/gauche, Y: haut/bas)

@export_group("Apparence")
@export var default_color: Color = Color("5c8de0ff")
@export var hover_color: Color = Color("295299ff")

# --- Paramètres de Caméra ---
@export_group("Caméra")
var target_zoom: float = 1.0
@export var zoom_speed = 0.25
@export var zoom_smoothness = 10.0
@export var drag_sensitivity = 1.0
var camera: Camera2D

func _ready():
	camera = get_node_or_null("Camera2D")
	
	# Chargement du fichier
	var data = load_geojson("res://Nouveau dossier/france.json")
	if data:
		draw_map(data)
	else:
		print("ERREUR : Impossible de charger le JSON. Vérifie le chemin.")

func _process(delta):
	if camera:
		camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), zoom_smoothness * delta)

func _unhandled_input(event):
	# Gestion du Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom + (zoom_speed * target_zoom), 0.05, 20.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom - (zoom_speed * target_zoom), 0.05, 20.0)

	# Gestion du Déplacement
	if event is InputEventMouseMotion and camera:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			camera.position -= event.relative * (1.0 / camera.zoom.x) * drag_sensitivity

# --- LOGIQUE DE DESSIN ---

func load_geojson(path: String):
	if not FileAccess.file_exists(path): return null
	var json_string = FileAccess.get_file_as_string(path)
	return JSON.parse_string(json_string)

func draw_map(data):
	if not data.has("features"): return
	
	for feature in data["features"]:
		var geom = feature["geometry"]
		var props = feature.get("properties", {})
		var region_name = props.get("nom", props.get("name", "Region")) # Gère "nom" ou "name"
		
		if geom["type"] == "Polygon":
			create_region(geom["coordinates"], region_name)
		elif geom["type"] == "MultiPolygon":
			for poly in geom["coordinates"]:
				create_region(poly, region_name)

func create_region(coords_array, region_name):
	var points = PackedVector2Array()
	# coords_array[0] contient les points extérieurs du polygone
	for coord in coords_array[0]:
		points.append(convert_coords(coord[0], coord[1]))
	
	var poly_node = Polygon2D.new()
	poly_node.polygon = points
	poly_node.color = default_color
	poly_node.color.a = 0.7 # Transparence pour voir si ça s'aligne bien
	poly_node.name = region_name
	
	# Système de détection de souris
	var area = Area2D.new()
	var collision = CollisionPolygon2D.new()
	collision.polygon = points
	
	area.add_child(collision)
	poly_node.add_child(area)
	add_child(poly_node)
	
	area.mouse_entered.connect(_on_region_entered.bind(poly_node))
	area.mouse_exited.connect(_on_region_exited.bind(poly_node))

func convert_coords(lon: float, lat: float) -> Vector2:
	# X : Différence de longitude * échelle
	var x = (lon - map_center_lon) * scale_factor
	
	# Y : Différence de latitude * échelle * correction d'étirement
	# On multiplie par -1 car en 2D Godot, le Y augmente vers le bas
	var y = -(lat - map_center_lat) * scale_factor * vertical_stretch
	
	return Vector2(x, y) + screen_offset

# --- INTERACTIONS ---

func _on_region_entered(node: Polygon2D):
	node.color = hover_color
	# print("Région : ", node.name)

func _on_region_exited(node: Polygon2D):
	node.color = default_color
