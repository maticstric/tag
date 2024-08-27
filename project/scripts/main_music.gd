extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	
	
func _process(_delta):
	if GameManager.muted:
		$AudioStreamPlayer.stream_paused = true
	else:
		$AudioStreamPlayer.stream_paused = false
