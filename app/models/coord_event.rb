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
    script_name = Game::SymbolReader.read_symbol(script)
    script_name ? script_name[:name] : 'Unknown Script'
  end
end
