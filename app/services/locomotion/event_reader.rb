require 'stringio'

module Locomotion
  class EventReader
    POINTER_SIZE = 4 # 32-bit architecture uses 4-byte pointers
    OBJECT_EVENT_TEMPLATE_SIZE = 24
    WARP_EVENT_SIZE = 8
    COORD_EVENT_SIZE = 12
    BG_EVENT_SIZE = 8

    MapEvents = Struct.new(
      :object_event_count,
      :warp_count,
      :coord_event_count,
      :bg_event_count,
      :object_events,
      :warps,
      :coord_events,
      :bg_events
    )

    ObjectEventTemplate = Struct.new(
      :local_id, :graphics_id, :kind, :x, :y,
      :elevation, :movement_type, :movement_range_x, :movement_range_y,
      :trainer_type, :trainer_range_berry_tree_id, :script, :flag_id
    )

    WarpEvent = Struct.new(:x, :y, :elevation, :warp_id, :map_num, :map_group)

    CoordEvent = Struct.new(:x, :y, :elevation, :trigger, :index, :script)

    BgEvent = Struct.new(:x, :y, :elevation, :kind, :hidden_item)

    def self.parse_map_events
      base_address = Locomotion::MapReader.fetch_map_header[:events]
      fixed_data = read_bytes(base_address, fixed_part_size)
      io = StringIO.new(fixed_data)

      object_event_count = io.read(1).unpack1('C')
      warp_count = io.read(1).unpack1('C')
      coord_event_count = io.read(1).unpack1('C')
      bg_event_count = io.read(1).unpack1('C')

      object_events_ptr = io.read(POINTER_SIZE).unpack1('L<')
      warps_ptr = io.read(POINTER_SIZE).unpack1('L<')
      coord_events_ptr = io.read(POINTER_SIZE).unpack1('L<')
      bg_events_ptr = io.read(POINTER_SIZE).unpack1('L<')

      object_events = parse_object_events(object_events_ptr, object_event_count)
      warps = parse_warps(warps_ptr, warp_count)
      coord_events = parse_coord_events(coord_events_ptr, coord_event_count)
      bg_events = parse_bg_events(bg_events_ptr, bg_event_count)

      MapEvents.new(
        object_event_count,
        warp_count,
        coord_event_count,
        bg_event_count,
        object_events,
        warps,
        coord_events,
        bg_events
      )
    end

    def self.parse_object_events(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * OBJECT_EVENT_TEMPLATE_SIZE)
      io = StringIO.new(data)

      count.times.map do
        local_id = io.read(1).unpack1('C')
        graphics_id = io.read(1).unpack1('C')
        kind = io.read(1).unpack1('C')
        x = io.read(2).unpack1('s<')
        y = io.read(2).unpack1('s<')
        elevation = io.read(1).unpack1('C')
        movement_type = io.read(1).unpack1('C')
        movement_range_x = io.read(1).unpack1('C') >> 4
        movement_range_y = io.read(1).unpack1('C') & 0xF
        trainer_type = io.read(2).unpack1('S<')
        trainer_range_berry_tree_id = io.read(2).unpack1('S<')
        script = io.read(POINTER_SIZE).unpack1('L<')
        flag_id = io.read(2).unpack1('S<')

        ObjectEventTemplate.new(
          local_id, graphics_id, kind, x, y,
          elevation, movement_type, movement_range_x, movement_range_y,
          trainer_type, trainer_range_berry_tree_id, script, flag_id
        )
      end
    end

    def self.parse_warps(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * WARP_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<')
        y = io.read(2).unpack1('s<')
        elevation = io.read(1).unpack1('C')
        warp_id = io.read(1).unpack1('C')
        map_num = io.read(1).unpack1('C')
        map_group = io.read(1).unpack1('C')

        WarpEvent.new(x, y, elevation, warp_id, map_num, map_group)
      end
    end

    def self.parse_coord_events(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * COORD_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<')
        y = io.read(2).unpack1('s<')
        elevation = io.read(1).unpack1('C')
        trigger = io.read(2).unpack1('S<')
        index = io.read(2).unpack1('S<')
        script = io.read(POINTER_SIZE).unpack1('L<')

        CoordEvent.new(x, y, elevation, trigger, index, script)
      end
    end

    def self.parse_bg_events(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * BG_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<')
        y = io.read(2).unpack1('s<')
        elevation = io.read(1).unpack1('C')
        kind = io.read(1).unpack1('C')
        hidden_item = io.read(POINTER_SIZE).unpack1('L<')

        BgEvent.new(x, y, elevation, kind, hidden_item)
      end
    end

    def self.read_bytes(address, length)
      memory_data = Retroarch::MemoryReader.read_bytes(address, length)
      memory_data.map { |byte| byte.to_i(16).chr }.join
    end

    def self.fixed_part_size
      4 + (4 * POINTER_SIZE)
    end
  end
end
