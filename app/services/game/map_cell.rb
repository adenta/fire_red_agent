module Game
  class MapCell
    NIL_METATILE_ID = 1023

    def initialize(tile, events)
      raise ArgumentError, 'Tile cannot be nil' if tile.nil?

      @tile = tile
      @events = events || []
    end

    def walkable?
      non_nil_metatile = @tile.metatile_id != NIL_METATILE_ID
      no_collision = @tile.collision == 0

      non_nil_metatile && no_collision
    end

    def metatile_id
      @tile.metatile_id
    end

    def metatile_behavior
      @tile.metatile_behavior
    end
  end
end
