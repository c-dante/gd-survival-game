# Weapon System

[Data sheet](https://docs.google.com/spreadsheets/d/1FkvFWZtLFzFhl9jPzdnoybg0r700ZM4g6ZOwygkKAIY/edit?gid=0#gid=0)

First pass at weapons. The pattern I have here is:

- Make a new scene as a Node2D, attach a script, standard GD component-based stuff
	- This serves as the base logic for the component
	- Inherit the weapon class
	- This generally has nothing in it and instead "spawns" and manages projectils
	- Add a new enum to Weapons.md
	- Make the get_type return that new enum
	- See TestArena global for the "add a weapon" logic, per weapon class
	- Add an "AcquireChoice" static method so we know how to get the first one, see "Level Ups"
- Configure the props
	- Weapons have Props record class that make them data driven
	- One props instance per-level, usually
	- Level up stuff is handled by current + next props, in array order
- Level Ups
	- Level up works on a "Choices" model
	- See level up ui for that
	- A choice has some metadata and can be anything
	- Weapons usually send themselves as the metadata, so that "set level" can get called
