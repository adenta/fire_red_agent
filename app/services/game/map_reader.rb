module Game
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

  TileData = Struct.new(:metatile_id, :collision, :elevation, :metatile_behavior)

  class MapReader
    def self.fetch_map_cells
      tiles = TileReader.fetch_tile_data
      row_size = fetch_map_dimensions[:map_width]
      metatile_behaviors = TileReader.fetch_metatile_behaviors

      grid = tiles.each_slice(row_size).to_a

      grid.map do |row|
        row.map do |tile|
          behavior_id = metatile_behaviors[tile.metatile_id].rjust(2, '0').upcase
          tile.metatile_behavior = Game::MetatileBehaviors::METATILE_BEHAVIORS[behavior_id.upcase]
          raise 'Must have a behavior' unless tile.metatile_behavior

          Game::MapCell.new(tile, [])
        end
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
  end
end
