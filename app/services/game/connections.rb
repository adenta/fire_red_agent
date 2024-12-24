module Game
  class Connections
    @data = {

      'MAP_CELADON_CITY': {
        "connections": [{ "map": 'MAP_ROUTE16', "offset": 10, "direction": 'left' },
                        { "map": 'MAP_ROUTE7', "offset": 10, "direction": 'right' }]
      },

      'MAP_CERULEAN_CITY': {
        "connections": [{ "map": 'MAP_ROUTE24', "offset": 12, "direction": 'up' },
                        { "map": 'MAP_ROUTE5', "offset": 0, "direction": 'down' }, { "map": 'MAP_ROUTE4', "offset": 10, "direction": 'left' }, { "map": 'MAP_ROUTE9', "offset": 10, "direction": 'right' }]
      },

      'MAP_CINNABAR_ISLAND': {
        "connections": [{ "map": 'MAP_ROUTE21_SOUTH', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE20', "offset": 0, "direction": 'right' }]
      },

      'MAP_FIVE_ISLAND': {
        "connections": [{ "map": 'MAP_FIVE_ISLAND_WATER_LABYRINTH', "offset": -48, "direction": 'up' },
                        { "map": 'MAP_FIVE_ISLAND_MEADOW', "offset": 0, "direction": 'right' }]
      },

      'MAP_FIVE_ISLAND_MEADOW': {
        "connections": [{ "map": 'MAP_FIVE_ISLAND', "offset": 0, "direction": 'left' },
                        { "map": 'MAP_FIVE_ISLAND_MEMORIAL_PILLAR', "offset": 20, "direction": 'right' }]
      },

      'MAP_FIVE_ISLAND_MEMORIAL_PILLAR': {
        "connections": [{ "map": 'MAP_FIVE_ISLAND_MEADOW', "offset": -20, "direction": 'left' }]
      },

      'MAP_FIVE_ISLAND_RESORT_GORGEOUS': {
        "connections": [{ "map": 'MAP_FIVE_ISLAND_WATER_LABYRINTH', "offset": -48, "direction": 'down' }]
      },

      'MAP_FIVE_ISLAND_WATER_LABYRINTH': {
        "connections": [{ "map": 'MAP_FIVE_ISLAND_RESORT_GORGEOUS', "offset": 48, "direction": 'up' },
                        { "map": 'MAP_FIVE_ISLAND', "offset": 48, "direction": 'down' }]
      },

      'MAP_FUCHSIA_CITY': {
        "connections": [{ "map": 'MAP_ROUTE19', "offset": 12, "direction": 'down' },
                        { "map": 'MAP_ROUTE18', "offset": 10, "direction": 'left' }, { "map": 'MAP_ROUTE15', "offset": 10, "direction": 'right' }]
      },

      'MAP_INDIGO_PLATEAU_EXTERIOR': {
        "connections": [{ "map": 'MAP_ROUTE23', "offset": 0, "direction": 'down' }]
      },

      'MAP_LAVENDER_TOWN': {
        "connections": [{ "map": 'MAP_ROUTE10', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE12', "offset": 0, "direction": 'down' }, { "map": 'MAP_ROUTE8', "offset": 0, "direction": 'left' }]
      },

      'MAP_ONE_ISLAND': {
        "connections": [{ "map": 'MAP_ONE_ISLAND_TREASURE_BEACH', "offset": 0, "direction": 'down' },
                        { "map": 'MAP_ONE_ISLAND_KINDLE_ROAD', "offset": -120, "direction": 'right' }]
      },

      'MAP_ONE_ISLAND_KINDLE_ROAD': {
        "connections": [{ "map": 'MAP_ONE_ISLAND', "offset": 120, "direction": 'left' }]
      },

      'MAP_ONE_ISLAND_TREASURE_BEACH': {
        "connections": [{ "map": 'MAP_ONE_ISLAND', "offset": 0, "direction": 'up' }]
      },

      'MAP_PALLET_TOWN': {
        "connections": [{ "map": 'MAP_ROUTE1', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE21_NORTH', "offset": 0, "direction": 'down' }]
      },

      'MAP_PEWTER_CITY': {
        "connections": [{ "map": 'MAP_ROUTE2', "offset": 12, "direction": 'down' },
                        { "map": 'MAP_ROUTE3', "offset": 10, "direction": 'right' }]
      },

      'MAP_PROTOTYPE_SEVII_ISLE_6': {
        "connections": [{ "map": 'MAP_THREE_ISLAND', "offset": 0, "direction": 'up' }]
      },

      'MAP_PROTOTYPE_SEVII_ISLE_7': {
        "connections": [{ "map": 'MAP_THREE_ISLAND', "offset": 0, "direction": 'up' }]
      },

      'MAP_ROUTE1': {
        "connections": [{ "map": 'MAP_VIRIDIAN_CITY', "offset": -12, "direction": 'up' },
                        { "map": 'MAP_PALLET_TOWN', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE10': {
        "connections": [{ "map": 'MAP_LAVENDER_TOWN', "offset": 0, "direction": 'down' },
                        { "map": 'MAP_ROUTE9', "offset": 0, "direction": 'left' }]
      },

      'MAP_ROUTE11': {
        "connections": [{ "map": 'MAP_VERMILION_CITY', "offset": -10, "direction": 'left' },
                        { "map": 'MAP_ROUTE12', "offset": -60, "direction": 'right' }]
      },

      'MAP_ROUTE12': {
        "connections": [{ "map": 'MAP_LAVENDER_TOWN', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE13', "offset": -48, "direction": 'down' }, { "map": 'MAP_ROUTE11', "offset": 60, "direction": 'left' }]
      },

      'MAP_ROUTE13': {
        "connections": [{ "map": 'MAP_ROUTE12', "offset": 48, "direction": 'up' },
                        { "map": 'MAP_ROUTE14', "offset": 0, "direction": 'left' }]
      },

      'MAP_ROUTE14': {
        "connections": [{ "map": 'MAP_ROUTE15', "offset": 40, "direction": 'left' },
                        { "map": 'MAP_ROUTE13', "offset": 0, "direction": 'right' }]
      },

      'MAP_ROUTE15': {
        "connections": [{ "map": 'MAP_FUCHSIA_CITY', "offset": -10, "direction": 'left' },
                        { "map": 'MAP_ROUTE14', "offset": -40, "direction": 'right' }]
      },

      'MAP_ROUTE16': {
        "connections": [{ "map": 'MAP_ROUTE17', "offset": 0, "direction": 'down' },
                        { "map": 'MAP_CELADON_CITY', "offset": -10, "direction": 'right' }]
      },

      'MAP_ROUTE17': {
        "connections": [{ "map": 'MAP_ROUTE16', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE18', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE18': {
        "connections": [{ "map": 'MAP_ROUTE17', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_FUCHSIA_CITY', "offset": -10, "direction": 'right' }]
      },

      'MAP_ROUTE19': {
        "connections": [{ "map": 'MAP_FUCHSIA_CITY', "offset": -12, "direction": 'up' },
                        { "map": 'MAP_ROUTE20', "offset": 40, "direction": 'left' }]
      },

      'MAP_ROUTE2': {
        "connections": [{ "map": 'MAP_PEWTER_CITY', "offset": -12, "direction": 'up' },
                        { "map": 'MAP_VIRIDIAN_CITY', "offset": -12, "direction": 'down' }]
      },

      'MAP_ROUTE20': {
        "connections": [{ "map": 'MAP_CINNABAR_ISLAND', "offset": 0, "direction": 'left' },
                        { "map": 'MAP_ROUTE19', "offset": -40, "direction": 'right' }]
      },

      'MAP_ROUTE21_NORTH': {
        "connections": [{ "map": 'MAP_PALLET_TOWN', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE21_SOUTH', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE21_SOUTH': {
        "connections": [{ "map": 'MAP_ROUTE21_NORTH', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_CINNABAR_ISLAND', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE22': {
        "connections": [{ "map": 'MAP_ROUTE23', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_VIRIDIAN_CITY', "offset": -10, "direction": 'right' }]
      },

      'MAP_ROUTE23': {
        "connections": [{ "map": 'MAP_INDIGO_PLATEAU_EXTERIOR', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE22', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE24': {
        "connections": [{ "map": 'MAP_CERULEAN_CITY', "offset": -12, "direction": 'down' },
                        { "map": 'MAP_ROUTE25', "offset": 0, "direction": 'right' }]
      },

      'MAP_ROUTE25': { "connections": [{ "map": 'MAP_ROUTE24', "offset": 0, "direction": 'left' }] },

      'MAP_ROUTE3': {
        "connections": [{ "map": 'MAP_ROUTE4', "offset": 60, "direction": 'up' },
                        { "map": 'MAP_PEWTER_CITY', "offset": -10, "direction": 'left' }]
      },

      'MAP_ROUTE4': {
        "connections": [{ "map": 'MAP_ROUTE3', "offset": -60, "direction": 'down' },
                        { "map": 'MAP_CERULEAN_CITY', "offset": -10, "direction": 'right' }]
      },

      'MAP_ROUTE5': {
        "connections": [{ "map": 'MAP_CERULEAN_CITY', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_SAFFRON_CITY_CONNECTION', "offset": 0, "direction": 'down' }]
      },

      'MAP_ROUTE6': {
        "connections": [{ "map": 'MAP_SAFFRON_CITY_CONNECTION', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_VERMILION_CITY', "offset": -12, "direction": 'down' }]
      },

      'MAP_ROUTE7': {
        "connections": [{ "map": 'MAP_CELADON_CITY', "offset": -10, "direction": 'left' },
                        { "map": 'MAP_SAFFRON_CITY_CONNECTION', "offset": -10, "direction": 'right' }]
      },

      'MAP_ROUTE8': {
        "connections": [{ "map": 'MAP_SAFFRON_CITY_CONNECTION', "offset": -10, "direction": 'left' },
                        { "map": 'MAP_LAVENDER_TOWN', "offset": 0, "direction": 'right' }]
      },

      'MAP_ROUTE9': {
        "connections": [{ "map": 'MAP_CERULEAN_CITY', "offset": -10, "direction": 'left' },
                        { "map": 'MAP_ROUTE10', "offset": 0, "direction": 'right' }]
      },

      'MAP_SAFFRON_CITY': {
        "connections": [{ "map": 'MAP_ROUTE5', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE6', "offset": 12, "direction": 'down' }, { "map": 'MAP_ROUTE7', "offset": 10, "direction": 'left' }, { "map": 'MAP_ROUTE8', "offset": 10, "direction": 'right' }]
      },

      'MAP_SAFFRON_CITY_CONNECTION': {
        "connections": [{ "map": 'MAP_ROUTE5', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_ROUTE6', "offset": 12, "direction": 'down' }, { "map": 'MAP_ROUTE7', "offset": 10, "direction": 'left' }, { "map": 'MAP_ROUTE8', "offset": 10, "direction": 'right' }]
      },

      'MAP_SEVEN_ISLAND': {
        "connections": [{ "map": 'MAP_SEVEN_ISLAND_TRAINER_TOWER', "offset": -48, "direction": 'up' },
                        { "map": 'MAP_SEVEN_ISLAND_SEVAULT_CANYON_ENTRANCE', "offset": 0, "direction": 'down' }]
      },

      'MAP_SEVEN_ISLAND_SEVAULT_CANYON': {
        "connections": [{ "map": 'MAP_SEVEN_ISLAND_TANOBY_RUINS', "offset": -48, "direction": 'down' },
                        { "map": 'MAP_SEVEN_ISLAND_SEVAULT_CANYON_ENTRANCE', "offset": -20, "direction": 'left' }]
      },

      'MAP_SEVEN_ISLAND_SEVAULT_CANYON_ENTRANCE': {
        "connections": [{ "map": 'MAP_SEVEN_ISLAND', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_SEVEN_ISLAND_SEVAULT_CANYON', "offset": 20, "direction": 'right' }]
      },

      'MAP_SEVEN_ISLAND_TANOBY_RUINS': {
        "connections": [{ "map": 'MAP_SEVEN_ISLAND_SEVAULT_CANYON', "offset": 48, "direction": 'up' }]
      },

      'MAP_SEVEN_ISLAND_TRAINER_TOWER': {
        "connections": [{ "map": 'MAP_SEVEN_ISLAND', "offset": 48, "direction": 'down' }]
      },

      'MAP_SIX_ISLAND': {
        "connections": [{ "map": 'MAP_SIX_ISLAND_WATER_PATH', "offset": -40, "direction": 'right' }]
      },

      'MAP_SIX_ISLAND_GREEN_PATH': {
        "connections": [{ "map": 'MAP_SIX_ISLAND_OUTCAST_ISLAND', "offset": 0, "direction": 'up' },
                        { "map": 'MAP_SIX_ISLAND_WATER_PATH', "offset": 0, "direction": 'right' }]
      },

      'MAP_SIX_ISLAND_OUTCAST_ISLAND': {
        "connections": [{ "map": 'MAP_SIX_ISLAND_GREEN_PATH', "offset": 0, "direction": 'down' }]
      },

      'MAP_SIX_ISLAND_RUIN_VALLEY': {
        "connections": [{ "map": 'MAP_SIX_ISLAND_WATER_PATH', "offset": -80, "direction": 'right' }]
      },

      'MAP_SIX_ISLAND_WATER_PATH': {
        "connections": [{ "map": 'MAP_SIX_ISLAND_GREEN_PATH', "offset": 0, "direction": 'left' },
                        { "map": 'MAP_SIX_ISLAND', "offset": 40, "direction": 'left' }, { "map": 'MAP_SIX_ISLAND_RUIN_VALLEY', "offset": 80, "direction": 'left' }]
      },

      'MAP_THREE_ISLAND': {
        "connections": [{ "map": 'MAP_THREE_ISLAND_PORT', "offset": 0, "direction": 'down' },
                        { "map": 'MAP_THREE_ISLAND_BOND_BRIDGE', "offset": 0, "direction": 'left' }]
      },

      'MAP_THREE_ISLAND_BOND_BRIDGE': {
        "connections": [{ "map": 'MAP_THREE_ISLAND', "offset": 0, "direction": 'right' }]
      },

      'MAP_THREE_ISLAND_PORT': {
        "connections": [{ "map": 'MAP_THREE_ISLAND', "offset": 0, "direction": 'up' }]
      },

      'MAP_TWO_ISLAND': {
        "connections": [{ "map": 'MAP_TWO_ISLAND_CAPE_BRINK', "offset": 24, "direction": 'up' }]
      },

      'MAP_TWO_ISLAND_CAPE_BRINK': {
        "connections": [{ "map": 'MAP_TWO_ISLAND', "offset": -24, "direction": 'down' }]
      },

      'MAP_VERMILION_CITY': {
        "connections": [{ "map": 'MAP_ROUTE6', "offset": 12, "direction": 'up' },
                        { "map": 'MAP_ROUTE11', "offset": 10, "direction": 'right' }]
      },

      'MAP_VIRIDIAN_CITY': {
        "connections": [{ "map": 'MAP_ROUTE2', "offset": 12, "direction": 'up' },
                        { "map": 'MAP_ROUTE1', "offset": 12, "direction": 'down' }, { "map": 'MAP_ROUTE22', "offset": 10, "direction": 'left' }]
      }
    }
    def self.to_map_name(name)
      # Remove trailing "_Layout"
      base = name.sub(/_Layout$/, '')
      # Insert underscores before uppercase letters, then uppercase everything
      snake_case = base.gsub(/([a-z0-9])([A-Z])/, '\1_\2').upcase
      # Prepend "LAYOUT_"
      "MAP_#{snake_case}"
    end

    def self.fetch_map_connections
      layout_name = Game::MapReader.fetch_map_name
      map_name = to_map_name(layout_name).to_sym
      @data[map_name][:connections]
    end
  end
end
