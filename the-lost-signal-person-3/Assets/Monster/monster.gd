extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("idle")

func _physics_process(delta):
	velocity = Vector2.ZERO
	move_and_slide()
