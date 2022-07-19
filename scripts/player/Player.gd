class_name Player
extends Node2D

# INDEXES
# 0 = Coal, 1 = Iron,
var stats : PlayerStats setget set_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_stats(new_stats: PlayerStats) -> void:
	stats = new_stats
	set_physics_process(stats != null)

