module Locomotion
  G_BACKUP_MAP_DATA = 0x02031dfc
  G_BACKUP_MAP_DATA_LENGTH = 0x2800

  class MapReader
    def self.fetch_as_matrix
      memory_data = Retroarch::MemoryReader.read_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      # TODO(adenta) this shouldn't be hard coded
      row_size = 78

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
            0
          when %w[0 1]
            1
          when %w[1 0]
            2
          when %w[1 1]
            3
          end
        end
      end
    end

    def self.fetch_as_text
      matrix = fetch_as_matrix

      matrix.map { |row| row.join }
    end
  end
end
