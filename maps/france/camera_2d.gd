extends Camera2D

# --- Paramètres de Zoom ---
@export var zoom_speed = 0.25      # Force de chaque coup de molette
@export var zoom_smoothness = 10.0 # Vitesse de la transition (plus c'est haut, plus c'est rapide)
@export var min_zoom = 0.01
@export var max_zoom = 10.0

# --- Paramètres de Déplacement ---
@export var drag_sensitivity = 1.0
@export var start_zoom = 0.1

# Variables internes pour le lissage
var target_zoom: float

func _ready():
	# On initialise la cible au zoom de départ
	target_zoom = start_zoom
	zoom = Vector2(start_zoom, start_zoom)

func _process(delta):
	# On rapproche doucement le zoom actuel vers le zoom cible (lerp)
	var new_zoom = lerp(zoom.x, target_zoom, zoom_smoothness * delta)
	zoom = Vector2(new_zoom, new_zoom)

func _unhandled_input(event):
	# --- Gestion du Zoom (Molette) ---
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				add_zoom(-zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				add_zoom(zoom_speed)

	# --- Gestion du Déplacement (Drag) ---
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			# On divise par zoom.x pour que la vitesse de drag s'adapte à la hauteur
			position -= event.relative * (1.0 / zoom.x) * drag_sensitivity

func add_zoom(delta):
	# On change la CIBLE du zoom, pas le zoom directement
	# On multiplie par target_zoom pour que le zoom soit proportionnel (plus fluide quand on est loin)
	target_zoom = clamp(target_zoom - delta * target_zoom, min_zoom, max_zoom)
