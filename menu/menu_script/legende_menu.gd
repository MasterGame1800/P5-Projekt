"""
This script defines the AutoDocumentation class, which extends the Control class in Godot.
It provides functionality for filtering and displaying UI elements based on user input in a search bar.

Attributes:
    bewohner: List of child nodes under GridContainerBewohner.
    werwölfe: List of child nodes under GridContainerWerwolf.
    solo: List of child nodes under GridContainerSolo.
    switch: List of child nodes under GridContainerSwitch.
    items: Combined list of all child nodes from the above categories.
    matches: List to store nodes that match the search query.

Methods:
    _on_searchbar_text_changed(new_text):
        Handles the text change event in the search bar. Filters and displays UI elements based on the input text.

    _on_button_back_pressed():
        Handles the back button press event. Hides the current UI element and returns to the parent.
"""

class_name AutoDocumentation extends Control

# Initialize variables with child nodes from specific containers
@onready var bewohner = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerBewohner.get_children()
@onready var werwölfe = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerWerwolf.get_children()
@onready var solo = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerSolo.get_children()
@onready var switch = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/GridContainerSwitch.get_children()
@onready var items = bewohner + werwölfe + solo + switch  # Combine all child nodes into a single list
var matches = []  # List to store matching nodes based on search query

func _on_searchbar_text_changed(new_text):
    """
    Handles the text change event in the search bar.

    Args:
        new_text (String): The new text entered in the search bar.

    Behavior:
        - Converts the input text to lowercase.
        - If the input is empty, shows all items and relevant sections.
        - Otherwise, filters items whose names contain the input text and hides irrelevant sections.
    """
    new_text = new_text.to_lower()  # Convert input text to lowercase for case-insensitive comparison
    if new_text == "":
        # Show all items and sections if the search bar is empty
        for i in items:
            i.show()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Intro.show()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Dorfbewohner.show()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Werwölfe.show()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Wechselnde.show()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Einzelspieler.show()
        return
    matches.clear()  # Clear previous matches
    for i in items:
        # Check if the item's name contains the search text
        if new_text in i.name.to_lower():
            matches.append(i)
    for i in items:
        if i in matches:
            i.show()  # Show matching items
            # Hide irrelevant sections
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Intro.hide()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Dorfbewohner.hide()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Werwölfe.hide()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Wechselnde.hide()
            $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Einzelspieler.hide()
        else:
            i.hide()  # Hide non-matching items

func _on_button_back_pressed() -> void:
    """
    Handles the back button press event.

    Behavior:
        - Sets the visibility of the current UI element to false.
        - Returns to the parent node.
    """
    visible = false  # Hide the current UI element
    get_parent()  # Return to the parent node
