extends Node2D

class_name AnimationComponent

signal animation_is_finished(anim_name: String)

signal facing_direction_changed(facing_right: bool)

@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

var playback: AnimationNodeStateMachinePlayback

func _ready():
	animation_tree.active = true
	animation_tree.connect("animation_finished", _on_animation_tree_animation_finished)
	playback = animation_tree["parameters/playback"]

# Update Character Animation
func update_animation(direction: Vector2):
	animation_tree.set("parameters/Move/blend_position", direction.x)

# Update Face direction
func update_facing_direction(direction: Vector2):
	if direction.x > 0:
		sprite.flip_h = false
		
	elif direction.x < 0:
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", not sprite.flip_h)

func _on_animation_tree_animation_finished(anim_name):
	emit_signal("animation_is_finished", anim_name)

func play(animation_name: String):
	playback.travel(animation_name)
