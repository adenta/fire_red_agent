module Game
  class TileReader
    def self.tileset_metas
      keys = %i[primary_tileset secondary_tileset]
      rv = {}
      keys.each do |key|
        tileset_id = MapReader.fetch_map_layout[key]
        memory_data = Sky::MemoryReader.read_binary_bytes(tileset_id, 0x18)

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
      primary_memory_data = Sky::MemoryReader.read_binary_bytes(tileset_metas[:primary_tileset][:metatile_attributes],
                                                                MAX_METATILE_ATTRIBUTE_LENGTH)

      primary_behaviors = primary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      secondary_memory_data = Sky::MemoryReader.read_binary_bytes(tileset_metas[:secondary_tileset][:metatile_attributes],
                                                                  MAX_METATILE_ATTRIBUTE_LENGTH)

      secondary_behaviors = secondary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      primary_behaviors + secondary_behaviors
    end
  end
end
