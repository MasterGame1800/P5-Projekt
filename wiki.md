# Project Wiki Guide

## 1. Project Overview
This project is a game developed using the Godot Engine. It features a card-based gameplay mechanic with multiplayer support powered by Nakama. The game includes various characters, roles, and statuses, providing a rich and interactive experience.

## 2. Folder Structure
- **addons/**: Contains third-party plugins, including Nakama for multiplayer functionality.
- **assets/**: Stores all game assets such as card images, icons, and status textures.
- **docu/**: Documentation files, including this wiki guide and credits.
- **gameplay/**: Scripts and logic for the core gameplay mechanics.
  - **scripte/**: General gameplay scripts.
  - **scripte_ablauf/**: Scripts managing the game flow and player interactions.
  - **scripte_charakter/**: Scripts related to character properties and behaviors.
- **menu/**: Scripts and scenes for the game menu, including 3D and 2D elements.
- **multiplayer/**: Scripts for managing multiplayer functionality using Nakama.

## 3. Key Scripts and Their Roles
- **menu_script/cards.gd**: Manages card-related functionalities such as flipping, setting textures, and hover text.
- **menu_script/asset_manager.gd**: Handles loading of textures for roles and statuses.
- **gameplay/scripte_ablauf/Spielablauf.gd**: Controls the game flow, including player interactions and effects.
- **multiplayer/NakamaManager.gd**: Manages multiplayer sessions and player data using Nakama.

## 4. Assets
- **Cards**: Located in `assets/cards/`, these include images for various roles such as "Child.png" and "Wolf.png".
- **Status Icons**: Located in `assets/status/`, these include icons for statuses like "enchanted.png" and "love.png".
- **Icons**: Located in `assets/Icons/`, these include UI elements like "back_icon.png" and "Setting_Wheel.png".

## 5. Gameplay Logic
- **Character Management**: Scripts in `gameplay/scripte_charakter/` define character properties and interactions.
- **Game Flow**: Scripts in `gameplay/scripte_ablauf/` manage the sequence of events, such as setting cards and applying effects.
- **Card Mechanics**: The `menu_script/cards.gd` script handles card-specific actions like flipping and assigning textures.

## 6. Multiplayer Integration
The project uses Nakama for multiplayer functionality. The `multiplayer/NakamaManager.gd` script manages player sessions, data synchronization, and interactions.

## 7. How to Contribute
1. Clone the repository.
2. Set up the Godot Engine (version specified in `project_metadata.cfg`).
3. Follow the coding standards and structure.
4. Submit pull requests with clear descriptions of changes.

## 8. Getting Started
1. Install the Godot Engine.
2. Open the project using the `project.godot` file.
3. Run the game to test the current build.
4. Modify scripts or assets as needed to contribute or customize.