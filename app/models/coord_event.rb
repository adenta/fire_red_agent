class CoordEvent
  attr_accessor :x, :y, :elevation, :trigger, :index, :script

  def initialize(x, y, elevation, trigger, index, script)
    @x = x
    @y = y
    @elevation = elevation
    @trigger = trigger
    @index = index
    @script = script
  end

  def to_s
    Game::SymbolReader.read_symbol(script)[:name]
  end
end
