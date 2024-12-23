require 'stringio'
require 'json'

module Game
  class EventReader
    OFFSET = 7
    POINTER_SIZE = 4 # 32-bit pointers

    # Sizes deduced from the given C structs and alignment on GBA
    # struct MapEvents: 4 counts (1 byte each) + 4 pointers (4 bytes each) = 4 + 16 = 20 bytes total
    FIXED_PART_SIZE = 4 + (4 * POINTER_SIZE) # = 20

    # struct ObjectEventTemplate is known to be 0x18 (24) bytes total.
    # Layout (normal kind):
    # 0x00: u8 localId
    # 0x01: u8 graphicsId
    # 0x02: u8 kind
    # 0x03: u8 padding
    # 0x04-0x05: s16 x
    # 0x06-0x07: s16 y
    # union normal or clone at 0x08 (8 bytes)
    # 0x10-0x13: const u8 *script (4 bytes)
    # 0x14-0x15: u16 flagId
    # 0x16-0x17: padding to align total size to 24 bytes
    OBJECT_EVENT_TEMPLATE_SIZE = 24

    # struct WarpEvent (confirmed size from definition):
    # s16 x (2), s16 y (2), u8 elevation, u8 warpId, u8 mapNum, u8 mapGroup = 8 bytes total
    WARP_EVENT_SIZE = 8

    # struct CoordEvent:
    # u16 x(2), u16 y(2), u8 elevation(1), then alignment padding, u16 trigger(2), u16 index(2), pointer(4)
    # Likely layout:
    # 0x0-1: u16 x
    # 0x2-3: u16 y
    # 0x4:   u8 elevation
    # 0x5:   u8 padding (to align next field)
    # 0x6-7: u16 trigger
    # 0x8-9: u16 index
    # 0xA-B: padding (to align pointer)
    # 0xC-F: pointer script (4 bytes)
    # Total = 16 bytes
    COORD_EVENT_SIZE = 16

    # struct BgEvent:
    # u16 x(2), u16 y(2), u8 elevation(1), u8 kind(1), then union { const u8* or u32 } (4 bytes), with alignment
    # Layout:
    # 0x0-1: u16 x
    # 0x2-3: u16 y
    # 0x4:   u8 elevation
    # 0x5:   u8 kind
    # 0x6-7: padding (2 bytes)
    # 0x8-B: 4 bytes union (pointer or u32)
    # Total = 12 bytes
    BG_EVENT_SIZE = 12

    def self.parse_map_events
      base_address = Game::MapReader.fetch_map_header[:events]

      fixed_data = read_bytes(base_address, FIXED_PART_SIZE)
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
        io.read(1) # padding
        x = io.read(2).unpack1('s<') + OFFSET
        y = io.read(2).unpack1('s<') + OFFSET

        elevation = nil
        movement_type = nil
        movement_range_x = nil
        movement_range_y = nil
        trainer_type = nil
        trainer_range_berry_tree_id = nil
        target_local_id = nil
        target_map_num = nil
        target_map_group = nil

        # The union depends on kind. Assuming kind=0 -> normal, else clone:
        if kind == 0
          # Normal
          elevation = io.read(1).unpack1('C')
          movement_type = io.read(1).unpack1('C')
          range_word = io.read(2).unpack1('s<')
          movement_range_x = range_word & 0xF
          movement_range_y = (range_word >> 4) & 0xF
          trainer_type = io.read(2).unpack1('s<')
          trainer_range_berry_tree_id = io.read(2).unpack1('s<')
        else
          # Clone
          target_local_id = io.read(1).unpack1('C')
          io.read(3) # padding
          target_map_num = io.read(2).unpack1('s<')
          target_map_group = io.read(2).unpack1('s<')
        end

        script = io.read(4).unpack1('L<')
        flag_id = io.read(2).unpack1('s<')
        io.read(2) # final padding

        ObjectEventTemplate.new(
          local_id, graphics_id, kind, x, y,
          elevation, movement_type, movement_range_x, movement_range_y,
          trainer_type, trainer_range_berry_tree_id, script, flag_id,
          target_local_id, target_map_num, target_map_group
        )
      end
    end

    def self.parse_warps(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * WARP_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<') + OFFSET
        y = io.read(2).unpack1('s<') + OFFSET
        elevation = io.read(1).unpack1('C')
        warp_id = io.read(1).unpack1('C')
        map_num = io.read(1).unpack1('C')
        map_group = io.read(1).unpack1('C')
        warp_type = determine_warp_type(warp_id) # New logic to determine warp type

        WarpEvent.new(x, y, elevation, warp_id, map_num, map_group, warp_type)
      end
    end

    def self.determine_warp_type(warp_id)
      # Logic to determine warp type based on warp_id or other criteria
      # For example:
      case warp_id
      when 1..10
        'door'
      when 11..20
        'stairs'
      else
        'unknown'
      end
    end

    def self.parse_coord_events(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * COORD_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<') + OFFSET
        y = io.read(2).unpack1('s<') + OFFSET
        elevation = io.read(1).unpack1('C')
        padding = io.read(1) # alignment padding
        trigger = io.read(2).unpack1('s<')
        index = io.read(2).unpack1('s<')
        io.read(2) # another padding for alignment
        script = io.read(4).unpack1('L<')

        CoordEvent.new(x, y, elevation, trigger, index, script)
      end
    end

    def self.parse_bg_events(address, count)
      return [] if count.zero?

      data = read_bytes(address, count * BG_EVENT_SIZE)
      io = StringIO.new(data)

      count.times.map do
        x = io.read(2).unpack1('s<') + OFFSET
        y = io.read(2).unpack1('s<') + OFFSET
        elevation = io.read(1).unpack1('C')
        kind = io.read(1).unpack1('C')
        io.read(2) # padding for alignment
        hidden_item_or_script = io.read(4).unpack1('L<')

        BgEvent.new(x, y, elevation, kind, hidden_item_or_script)
      end
    end

    def self.read_bytes(address, length)
      memory_data = Sky::MemoryReader.read_bytes(address, length)
      memory_data.map { |byte| byte.to_i(16).chr }.join
    end

    def self.to_json
      parse_map_events.to_h.to_json
    end
  end
end
