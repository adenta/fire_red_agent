# README

Things to refactor

`MapReader` and `EventReader` should probably be abstracted into a 'reader' module IMO

refactor where the methods are, and what classes they are linked to.
write tests that can be run repeatably. have at least two locations and have the tests to things. tests shouldn't run LLM's
change the definition of a map cell. remove the 'tile' and spread it out to the class

seperate map_reader into another class

remove map_cell tile struct, make the metatile id's properties on the map_cell

derive the metatile_id from the events array, perhaps?

old notes doc

Pokémon stream next steps:
-5. migrate back to sky emu

- 4. Use the real coordinates from the event objects and the script from the event templates
     -2. Rollback path finding. The last step stuff isn’t really working out. Couple it with a new rotate algorithm
- 3. Figure out why mom wasn’t showing up in the map preview. Figure out why mom was considered walkable
- 1. Figure out how to get the chat memory state to persist. Use system and user prompts, and render them in the loop, removing older messages as needed
- 6. Build a map of how all the locations connect to one another (pallet town leads to route 1 on the north, and route 38 on the south. Consider putting fake warps to guide the player)

DEC30

- have the pathfinding look for any available warp to the next map, not just the leftmost walkable cell
- get retroarch controller support
- set up a battle handler
- get things working on linux
