extends CharacterBody2D

const SPEED = 300.0

@onready var posessed:= false
@onready var color_rect: ColorRect = $ColorRect

func _physics_process(_delta: float) -> void:
	if posessed:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		color_rect.visible = true
		if direction != Vector2.ZERO:
			velocity = direction * SPEED
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)

		# 3. Bewegung ausführen
		move_and_slide()
	else:
		color_rect.visible = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Prüfen, ob das Event ein Mausklick ist
	if event is InputEventMouseButton:
		# Prüfen, ob die linke Maustaste gedrückt wurde (und nicht losgelassen)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Area2D wurde angeklickt!")
			on_click_action()

func on_click_action():
	# Hier kommt dein Code hin, was beim Klick passieren soll
	posessed = !posessed
	
