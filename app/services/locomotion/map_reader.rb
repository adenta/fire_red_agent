module Locomotion
  G_BACKUP_MAP_DATA = 0x02031dfc
  G_BACKUP_MAP_DATA_LENGTH = 0x2800

  V_MAP = 0x03005040
  V_MAP_LENGTH = 12

  G_MAP_HEADER = 0x02036dfc
  G_MAP_HEADER_LENGTH = 0x1c

  MAPGRID_METATILE_ID_MASK = 0x03FF
  MAPGRID_COLLISION_MASK   = 0x0C00
  MAPGRID_ELEVATION_MASK   = 0xF000
  MAPGRID_COLLISION_SHIFT  = 10
  MAPGRID_ELEVATION_SHIFT  = 12

  PLAYER_LOCATION = 0x2036e48

  MAX_METATILE_ATTRIBUTE_LENGTH = 0xa00

  TileData = Struct.new(:metatile_id, :collision, :elevation, :metatile_behavior) do
    def to_s
      collision.to_s
    end
  end

  class MapReader
    def self.fetch_tile_data
      # Gotta rewrite this using the pack stuff
      memory_data = Retroarch::MemoryReader.read_binary_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      tiles = []
      # Assuming memory_data is a String of bytes
      (0...(memory_data.bytesize / 2)).each do |i|
        low_byte  = memory_data.getbyte(i * 2)
        high_byte = memory_data.getbyte(i * 2 + 1)
        raw       = (high_byte << 8) | low_byte
        tiles << parse_tile_data(raw)
      end
      tiles
    end

    def self.fetch_map_cells
      tiles = fetch_tile_data
      row_size = fetch_map_dimensions[:map_width]
      metatile_behaviors = fetch_metatile_behaviors

      grid = tiles.each_slice(row_size).to_a

      # parsed_events = Locomotion::EventReader.parse_map_events

      # all_events = parsed_events[:object_events] + parsed_events[:warps] + parsed_events[:coord_events] + parsed_events[:bg_events]

      # all_events.each do |event|
      #   grid[event.y + 7][event.x + 7] = 'E'
      # end

      grid.map do |row|
        row.map do |tile|
          behavior_id = metatile_behaviors[tile.metatile_id].rjust(2, '0').upcase
          tile.metatile_behavior = Locomotion::MetatileBehaviors::METATILE_BEHAVIORS[behavior_id.upcase]
          raise 'Must have a behavior' unless tile.metatile_behavior

          Locomotion::MapCell.new(tile, [])
        end
      end
    end

    def self.fetch_colisions
      collisions = []
      map_cells = fetch_map_cells
      map_cells.each_with_index.map do |row, x|
        row.each_with_index.map do |cell, y|
          collisions << "#{x}, #{y}" if !cell.walkable? && cell.metatile_id != 1023
        end.join(', ')
      end

      collisions
    end

    def self.fetch_metatile_ids
      metatile_behaviors = fetch_metatile_behaviors
      fetch_map_cells.map do |row|
        row.map do |cell|
          behavior_id = metatile_behaviors[cell.metatile_id]
          Locomotion::MetatileBehaviors::METATILE_BEHAVIORS[behavior_id.upcase] || ' '
        end.join(', ')
      end
    end

    def self.fetch_uniq_metatile_ids
      fetch_tile_data.map(&:metatile_id).uniq
    end

    def self.fetch_uniq_metatile_id_metadata
      uniq_ids = fetch_uniq_metatile_ids
      uniq_ids_under_640 = uniq_ids.select { |id| id < 640 }
      tileset = fetch_primary_tileset
      uniq_ids_under_640.each do |id|
        ap tileset[id]
      end
    end

    def self.fetch_map_dimensions
      memory_data = Retroarch::MemoryReader.read_bytes(V_MAP, V_MAP_LENGTH)

      map_width, map_height, map_location = memory_data.each_slice(4).to_a

      map_width.reverse.join.to_i(16)

      {
        map_width: map_width.reverse.join.to_i(16),
        map_height: map_height.reverse.join.to_i(16)

      }
    end

    def self.fetch_player_location
      memory_data = Retroarch::MemoryReader.read_bytes(PLAYER_LOCATION, 0x4)

      x, y = memory_data.each_slice(2).to_a.map(&:reverse).map(&:join).map { |x| x.to_i(16) }
      { x: x, y: y }
    end

    def self.fetch_map_header
      memory_data = Retroarch::MemoryReader.read_bytes(G_MAP_HEADER, G_MAP_HEADER_LENGTH)

      binary_data = memory_data.map { |byte| byte.to_i(16).chr }.join

      header = binary_data.unpack('V4v2C6')
      {
        map_layout: header[0],
        events: header[1],
        map_scripts: header[2],
        connections: header[3],
        music: header[4],
        map_layout_id: header[5],
        region_map_section_id: header[6],
        cave: header[7],
        weather: header[8],
        map_type: header[9],
        biking_allowed: header[10] & 0x01,
        allow_escaping: (header[11] & 0x01) != 0,
        allow_running: (header[11] & 0x02) != 0,
        show_map_name: (header[11] >> 2) & 0x3F,
        floor_num: header[12],
        battle_type: header[13]
      }
    end

    def self.fetch_map_layout
      memory_data = Retroarch::MemoryReader.read_binary_bytes(fetch_map_header[:map_layout], 0x1A)
      layout_data = memory_data.unpack('l<l<l<l<l<l<CC')
      {
        width: layout_data[0],
        height: layout_data[1],
        border: layout_data[2],
        map: layout_data[3],
        primary_tileset: layout_data[4],
        secondary_tileset: layout_data[5],
        border_width: layout_data[6],
        border_height: layout_data[7]
      }
    end

    def self.tileset_metas
      keys = %i[primary_tileset secondary_tileset]
      rv = {}
      keys.each do |key|
        tileset_id = fetch_map_layout[key]
        memory_data = Retroarch::MemoryReader.read_binary_bytes(tileset_id, 0x18)

        is_compressed = memory_data.getbyte(0) != 0
        is_secondary = memory_data.getbyte(1) != 0
        tiles = memory_data[4, 4].unpack1('L<')
        palettes = memory_data[8, 4].unpack1('L<')
        metatiles = memory_data[12, 4].unpack1('L<')
        callback = memory_data[16, 4].unpack1('L<')
        metatile_attributes = memory_data[20, 4].unpack1('L<')

        rv[key] = {
          is_compressed: is_compressed,
          is_secondary: is_secondary,
          tiles: tiles,
          palettes: palettes,
          metatiles: metatiles,
          callback: callback,
          metatile_attributes: metatile_attributes
        }
      end

      rv
    end

    def self.fetch_metatile_behaviors
      primary_memory_data = Retroarch::MemoryReader.read_binary_bytes(tileset_metas[:primary_tileset][:metatile_attributes],
                                                                      MAX_METATILE_ATTRIBUTE_LENGTH)

      primary_behaviors = primary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      secondary_memory_data = Retroarch::MemoryReader.read_binary_bytes(tileset_metas[:secondary_tileset][:metatile_attributes],
                                                                        MAX_METATILE_ATTRIBUTE_LENGTH)

      secondary_behaviors = secondary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      primary_behaviors + secondary_behaviors
    end

    # def self.fetch_primary_tileset
    #   memory_data = Retroarch::MemoryReader.read_binary_bytes(fetch_primary_tileset_meta[:metatiles],
    #                                                           MAX_METATILE_ATTRIBUTE_LENGTH)

    #   attributes = []
    #   memory_data.split('').each_slice(4) do |slice|
    #     raw = slice.join.unpack1('L<')
    #     attributes << {
    #       behavior: (raw & 0x000001ff) >> 0,
    #       terrain: (raw & 0x00003e00) >> 9,
    #       attribute_2: (raw & 0x0003c000) >> 14,
    #       attribute_3: (raw & 0x00fc0000) >> 18,
    #       encounter_type: (raw & 0x07000000) >> 24,
    #       attribute_5: (raw & 0x18000000) >> 27,
    #       layer_type: (raw & 0x60000000) >> 29,
    #       attribute_7: (raw & 0x80000000) >> 31
    #     }
    #   end
    #   attributes
    # end

    private_class_method def self.parse_tile_data(raw)
      metatile_id = raw & MAPGRID_METATILE_ID_MASK
      collision   = (raw & MAPGRID_COLLISION_MASK) >> MAPGRID_COLLISION_SHIFT
      elevation   = (raw & MAPGRID_ELEVATION_MASK) >> MAPGRID_ELEVATION_SHIFT
      TileData.new(metatile_id, collision, elevation)
    end
  end
end
