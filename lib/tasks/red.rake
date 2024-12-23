namespace :red do
  task loop: :environment do
    loop do
      MapMemory.create!(name: Game::MapReader.fetch_map_name)
      Intelligence::ConversationHandler.handle_conversation
      path = Intelligence::LocomotionHandler.calculate_path
      Game::Charter.chart_path(x: path[:x], y: path[:y])
      Sky::KeyboardService.a
    end
  end

  task launch_game: :environment do
    command = [
      '/Applications/RetroArch.app/Contents/MacOS/RetroArch',
      '-L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib"',
      Rails.root.join('db', 'data', 'games', 'firered.gba').to_s,
      "--appendconfig=#{Rails.root.join('db', 'data', 'retroarch_config', 'live-savestate.cfg')}"
    ].join(' ')

    system(command)
    puts 'Game launched successfully'
  end

  task benchmark_memory: :environment do
    V_MAP = 0x03005040
    V_MAP_LENGTH = 12

    G_MAP_HEADER = 0x02036dfc
    G_MAP_HEADER_LENGTH = 0x1c

    ap Sky::MemoryReader.read_bytes_packet(G_MAP_HEADER, G_MAP_HEADER_LENGTH)
    ap Sky::MemoryReader.read_bytes_packet(G_MAP_HEADER, G_MAP_HEADER_LENGTH)
  end
end
