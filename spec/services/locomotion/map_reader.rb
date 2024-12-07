require 'rails_helper'

RSpec.describe Locomotion::MapReader, type: :service do
  before(:all) do
    Retroarch::Instance.start
  end

  after(:all) do
    Retroarch::Instance.stop
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
