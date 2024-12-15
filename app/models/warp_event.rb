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

  def to_s
    raise NotImplementedError
  end
end
