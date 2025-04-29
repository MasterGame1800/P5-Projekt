"""
This script defines a simple process function for updating a label's text.

Functions:
- `_process(delta)`: Updates the text of the `$Label` node every frame.
"""

extends Node


func _process(delta):
	$Label.text = "warum so einfach"

