require 'rails_helper'

RSpec.describe Locomotion::MapReader, type: :service do
  @pid = nil
  before(:each) do
    command = '/Applications/RetroArch.app/Contents/MacOS/RetroArch -L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib" "./db/data/games/firered.gba" --appendconfig="/Users/andrew/fire_red_agent/db/data/retroarch_config/savestate.cfg"'
    @pid = spawn(command, out: '/dev/null', err: '/dev/null') # Redirects stdout and stderr
    Process.detach(@pid) # Detaches the process
    sleep(2) # Wait for initialization, adjust as necessary
  end

  after(:each) do
    if @pid
      Process.kill('KILL', @pid) # Sends the kill signal
      begin
        Process.wait(@pid)
      rescue StandardError
        nil
      end # Cleans up the process to avoid zombies
    end
  end
  describe '.fetch_map_header' do
    it 'returns the correct map header data' do
      expected_map_header = {
        "map_layout": 137_188_092,
        "events": 138_123_148,
        "map_scripts": 135_695_523,
        "connections": 0,
        "music": 300,
        "map_layout_id": 2,
        "region_map_section_id": 88,
        "cave": 0, "weather": 0,
        "map_type": 8,
        "biking_allowed": 0,
        "allow_escaping": false,
        "allow_running": false,
        "show_map_name": 0,
        "floor_num": nil,
        "battle_type": nil
      }

      expect(Locomotion::MapReader.fetch_map_header).to eq(expected_map_header)
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
