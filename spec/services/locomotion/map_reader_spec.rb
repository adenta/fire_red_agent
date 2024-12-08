require 'rails_helper'

RSpec.describe Locomotion::MapReader, type: :service do
  @pid = nil
  before(:all) do
    command = '/Applications/RetroArch.app/Contents/MacOS/RetroArch -L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib" "./db/data/games/firered.gba" --appendconfig="/Users/andrew/fire_red_agent/db/data/retroarch_config/savestate.cfg"'
    @pid = spawn(command)
    Process.detach(@pid)
  end

  after(:all) do
    Process.kill('KILL', @pid)
  end
  describe '.fetch_map_header' do
    it 'returns the correct map header data' do
      sleep 4.seconds
    end
  end

  describe '.fetch_tile_data' do
    it 'returns the correct tile data' do
      sleep 4.seconds
    end
  end

  describe '.fetch_map_dimensions' do
    it 'returns the correct map dimensions' do
      sleep 4.seconds
    end
  end
end
