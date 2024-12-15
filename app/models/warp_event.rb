class WarpEvent
  attr_accessor :x, :y, :elevation, :warp_id, :map_num, :map_group, :warp_type

  def initialize(x, y, elevation, warp_id, map_num, map_group, warp_type)
    @x = x
    @y = y
    @elevation = elevation
    @warp_id = warp_id
    @map_num = map_num
    @map_group = map_group
    @warp_type = warp_type
  end

  def map_group_num_key
    "group#{map_group}_num#{map_num}".to_sym
  end

  def to_s
    "Destination: #{Game::MapGroup::MAP_GROUP[map_group_num_key]}"
  end
end
