require 'rails_helper'

RSpec.describe Locomotion::MapReader, type: :service do
  before(:all) do
    command = '/Applications/RetroArch.app/Contents/MacOS/RetroArch -L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib" "./db/data/games/firered.gba" --appendconfig="/Users/andrew/fire_red_agent/db/data/retroarch_config/savestate.cfg"'
    system(command)
  end

  after(:all) do
    raise NotImplementedError
  end
  describe '.fetch_map_header' do
    it 'returns the correct map header data' do
      # Add your test implementation here
    end
  end

  describe '.fetch_tile_data' do
    it 'returns the correct tile data' do
      # Add your test implementation here
    end
  end

  describe '.fetch_map_dimensions' do
    it 'returns the correct map dimensions' do
      # Add your test implementation here
    end
  end
end
