module Locomotion
  class MapCell
    def initialize(tile, events)
      raise ArgumentError, 'Tile cannot be nil' if tile.nil?

      @tile = tile
      @events = events || []
    end

    def walkable?
      true
    end
  end
end
