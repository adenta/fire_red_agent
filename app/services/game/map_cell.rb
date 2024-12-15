module Game
  class MapCell
    NIL_METATILE_ID = 1023

    attr_reader :metatile_id, :collision, :elevation, :metatile_behavior
    attr_accessor :events

    def initialize(metatile_id:, collision:, elevation:, metatile_behavior:)
      raise ArgumentError, 'Metatile ID cannot be nil' if metatile_id.nil?

      @metatile_id = metatile_id
      @collision = collision
      @elevation = elevation
      @metatile_behavior = metatile_behavior
      @events = []
    end

    def walkable?
      non_nil_metatile = @metatile_id != NIL_METATILE_ID
      no_collision = @collision == 0
      # object_events = @events.select { |event| event.is_a?(EventReader::ObjectEventTemplate) }

      non_nil_metatile && no_collision # && object_events.empty?
    end
  end
end
