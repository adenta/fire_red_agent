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
      # im unsure if we actually want this check
      object_events = @events.select { |event| event.is_a?(ObjectEventTemplate) }

      warp_events = @events.select { |event| event.is_a?(WarpEvent) }

      warps_present = warp_events.any?

      normal_metatile_behavior = @metatile_behavior == Game::MetatileBehaviors::MB_NORMAL

      # if the metatile is normal, and a warp cell is present, it probably isnt a door
      normal_metatile_and_warp = warps_present && normal_metatile_behavior

      non_nil_metatile && no_collision && object_events.empty? && !normal_metatile_and_warp
    end
  end
end
