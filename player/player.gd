extends CharacterBody2D

var speed = 180
var facing = "down"

@onready var sprite = $AnimatedSprite2D
@onready var flashlight = find_child("Flashlight", true, false)


func _ready():
	var frames = SpriteFrames.new()
	var directions = ["down", "up", "left", "right"]

	for dir in directions:
		frames.add_animation("idle_" + dir)
		frames.set_animation_speed("idle_" + dir, 6)
		frames.set_animation_loop("idle_" + dir, true)

		for i in range(4):
			var path = "res://hooded_player/idle/" + dir + "/Frame_%02d.png" % i
			frames.add_frame("idle_" + dir, load(path))

		frames.add_animation("walk_" + dir)
		frames.set_animation_speed("walk_" + dir, 8)
		frames.set_animation_loop("walk_" + dir, true)

		for i in range(4):
			var path = "res://hooded_player/walk/" + dir + "/Frame_%02d.png" % i
			frames.add_frame("walk_" + dir, load(path))

	sprite.sprite_frames = frames
	sprite.play("idle_down")

	if flashlight != null:
		create_flashlight_beam()
	else:
		print("Flashlight node not found!")


func _physics_process(_delta):
	var direction = Input.get_vector(
		"ui_left", "ui_right", "ui_up", "ui_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			facing = "right" if direction.x > 0 else "left"
		else:
			facing = "down" if direction.y > 0 else "up"

		sprite.play("walk_" + facing)
	else:
		sprite.play("idle_" + facing)


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F and flashlight != null:
			flashlight.visible = not flashlight.visible


func create_flashlight_beam():
	var img = Image.create(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))

	for y in range(128):
		var distance = float(128 - y) / 128.0
		var width = distance * 120.0

		for x in range(256):
			var edge = 1.0 - abs(x - 128) / max(width, 1.0)

			if edge > 0:
				var alpha = 0.65 * edge
				img.set_pixel(x, y, Color(1, 1, 1, alpha))

	flashlight.texture = ImageTexture.create_from_image(img)
	flashlight.energy = 2.5
	flashlight.texture_scale = 3.0
	flashlight.position = Vector2(0, -10)
