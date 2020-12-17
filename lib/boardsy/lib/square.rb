class Square
  attr_accessor :value
  attr_reader :x, :y
  
  def initialize(value, x, y)
    @value,@x,@y = value,x,y
  end
  
  def coords
    [x, y]
  end
  
  def empty?
    value.nil?
  end
end