class BgEvent
  attr_accessor :x, :y, :elevation, :kind, :hidden_item_or_script

  def initialize(x, y, elevation, kind, hidden_item_or_script)
    @x = x
    @y = y
    @elevation = elevation
    @kind = kind
    @hidden_item_or_script = hidden_item_or_script
  end

  def to_s
    'asdf'
  end
end
