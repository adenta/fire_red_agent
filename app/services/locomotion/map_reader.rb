module Locomotion
  G_BACKUP_MAP_DATA = 0x02031dfc
  G_BACKUP_MAP_DATA_LENGTH = 0x2800

  V_MAP = 0x03005040
  V_MAP_LENGTH = 12

  G_MAP_HEADER = 0x02036dfc
  G_MAP_HEADER_LENGTH = 0x1c

  class MapReader
    def self.fetch_as_matrix
      # Gotta rewrite this using the pack stuff
      raise NotImplementedError
      memory_data = Retroarch::MemoryReader.read_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      # unsure why I need to multiply this by two
      row_size = fetch_map_dimensions[:map_width] * 2

      grid = memory_data.each_slice(row_size).to_a

      byte_grid = grid.map do |row|
        row.each_slice(2).to_a
      end

      byte_grid.map do |row|
        row.map do |pair|
          cell = pair.reverse.join

          binary_string = cell.to_i(16).to_s(2).rjust(16, '0').split('').reverse

          collision = [binary_string[10], binary_string[11]]

          case collision
          when %w[0 0]
            ' '
          when %w[0 1]
            '1'
          when %w[1 0]
            '2'
          when %w[1 1]
            '3'
          end
        end
      end
    end

    def self.fetch_as_text
      matrix = fetch_as_matrix

      matrix.map { |row| row.join }
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

    def self.fetch_map_events
      events_pointer = fetch_map_header[:events]
    end
  end
end
