module Game
  class TileReader
    def self.fetch_tile_data
      memory_data = Retroarch::MemoryReader.read_binary_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      tiles = []
      (0...(memory_data.bytesize / 2)).each do |i|
        low_byte  = memory_data.getbyte(i * 2)
        high_byte = memory_data.getbyte(i * 2 + 1)
        raw       = (high_byte << 8) | low_byte
        tiles << parse_tile_data(raw)
      end
      tiles
    end

    def self.fetch_metatile_behaviors
      primary_memory_data = Retroarch::MemoryReader.read_binary_bytes(MapReader.tileset_metas[:primary_tileset][:metatile_attributes],
                                                                    MAX_METATILE_ATTRIBUTE_LENGTH)

      primary_behaviors = primary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      secondary_memory_data = Retroarch::MemoryReader.read_binary_bytes(MapReader.tileset_metas[:secondary_tileset][:metatile_attributes],
                                                                      MAX_METATILE_ATTRIBUTE_LENGTH)

      secondary_behaviors = secondary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      primary_behaviors + secondary_behaviors
    end

    private_class_method def self.parse_tile_data(raw)
      metatile_id = raw & MAPGRID_METATILE_ID_MASK
      collision   = (raw & MAPGRID_COLLISION_MASK) >> MAPGRID_COLLISION_SHIFT
      elevation   = (raw & MAPGRID_ELEVATION_MASK) >> MAPGRID_ELEVATION_SHIFT
      MapReader::TileData.new(metatile_id, collision, elevation)
    end
  end
end
