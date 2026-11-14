extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.visible = true
	sprite.modulate = Color.WHITE
	sprite.play("Idle")
