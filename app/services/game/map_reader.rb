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

  G_MAIN = 0x030030f0

  class MapReader
    def self.fetch_map_data
      memory_data = Retroarch::MemoryReader.read_binary_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      data = []
      (0...(memory_data.bytesize / 2)).each do |i|
        low_byte  = memory_data.getbyte(i * 2)
        high_byte = memory_data.getbyte(i * 2 + 1)
        raw       = (high_byte << 8) | low_byte
        data << parse_data(raw)
      end
      data
    end

    def self.fetch_map_cells
      data = fetch_map_data
      row_size = fetch_map_dimensions[:map_width]
      row_count = fetch_map_dimensions[:map_height]

      metatile_behaviors = TileReader.fetch_metatile_behaviors
      map_events = EventReader.parse_map_events

      grid = data.each_slice(row_size).to_a

      map_cell_grid = grid.map do |row|
        row.map do |tile|
          behavior_id = metatile_behaviors[tile[:metatile_id]].rjust(2, '0').upcase
          tile[:metatile_behavior] = Game::MetatileBehaviors::METATILE_BEHAVIORS[behavior_id.upcase]
          unless tile[:metatile_behavior]
            tile[:metatile_behavior] = MetatileBehaviors::MB_NORMAL
            raise "Unknown metatile behavior: #{behavior_id}" unless tile[:metatile_id] == 1023
          end

          Game::MapCell.new(
            metatile_id: tile[:metatile_id],
            collision: tile[:collision],
            elevation: tile[:elevation],
            metatile_behavior: tile[:metatile_behavior]
          )
        end
      end

      # map_events.coord_events.each do |event|
      #   map_cell_grid[event.y][event.x].events << event
      # end

      # map_events.bg_events.each do |event|
      #   map_cell_grid[event.y][event.x].events << event
      # end

      map_events.object_event_templates.each do |event|
        map_cell_grid[event.y][event.x].events << event
      end

      map_events.warps.each do |event|
        map_cell_grid[event.y][event.x].events << event
      end

      map_cell_grid.first(row_count)
    end

    def self.fetch_map_name
      SymbolReader.read_symbol(fetch_map_header[:map_layout])[:name]
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

    # this is part of a larger struct
    # https://github.com/pret/pokefirered/blob/2a3e92e10f8353e167874d1d2f6b311560a2a80d/include/main.h#L11C1-L45C3
    # but parsing all of it was hard, grabbing the last byte is easy
    def self.in_battle?
      # Read the single byte at offset 0x439
      last_byte = Retroarch::MemoryReader.read_binary_bytes(G_MAIN + 0x439, 1).unpack1('C')
      # Extract the "inBattle" bit (bit 1)
      (last_byte >> 1) & 0x01 == 1
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

    private_class_method def self.parse_data(raw)
      metatile_id = raw & MAPGRID_METATILE_ID_MASK
      collision   = (raw & MAPGRID_COLLISION_MASK) >> MAPGRID_COLLISION_SHIFT
      elevation   = (raw & MAPGRID_ELEVATION_MASK) >> MAPGRID_ELEVATION_SHIFT
      {
        metatile_id: metatile_id,
        collision: collision,
        elevation: elevation
      }
    end
  end
end
