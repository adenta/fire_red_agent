# README

Things to refactor

`MapReader` and `EventReader` should probably be abstracted into a 'reader' module IMO

refactor where the methods are, and what classes they are linked to.
write tests that can be run repeatably. have at least two locations and have the tests to things. tests shouldn't run LLM's
change the definition of a map cell. remove the 'tile' and spread it out to the class

seperate map_reader into another class

remove map_cell tile struct, make the metatile id's properties on the map_cell

derive the metatile_id from the events array, perhaps?
