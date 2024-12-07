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

  TileData = Struct.new(:metatile_id, :collision, :elevation)

  class MapReader
    def self.fetch_map_data
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

    def self.parse_tile_data(raw)
      metatile_id = raw & MAPGRID_METATILE_ID_MASK
      collision   = (raw & MAPGRID_COLLISION_MASK) >> MAPGRID_COLLISION_SHIFT
      elevation   = (raw & MAPGRID_ELEVATION_MASK) >> MAPGRID_ELEVATION_SHIFT
      TileData.new(metatile_id, collision, elevation)
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
  end
end
