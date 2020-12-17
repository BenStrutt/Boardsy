class Board
  include Enumerable
  
  attr_reader :grid
  
  def initialize(rows, cols = rows, value: nil)
    @grid = Array.new(cols) do |n|
      Array.new(rows) do |m|
        x = m.next; y = cols - n
        value = yield(x,y,value) if block_given?
        Square.new(value, x, y)
      end
    end
  end
  
  def length
    grid.first.size
  end
  
  def width
    grid.size
  end
  
  def squares
    each.to_a
  end
  
  #TODO: write exception tests
  def square(*coords)
    coords = format_coords(coords)
    each { |square| return square if square.coords == coords }
    raise ArgumentError, 'Coordinates passed are out of bounds.'
  end
  
  def col(*coords)
    grid.transpose[format_coords(coords).first - 1].reverse
  end
  
  alias :column :col
  
  def row(*coords)
    grid[grid.size - (format_coords(coords).last)]
  end
  
  # TODO: write tests for diagonals
  def diagonals(coords)
    coords = format_coords(coords)
    diagonals = []
    length = (1..grid.size); width = (1..grid[0].size)
    [[1,1],[-1,1]].each do |m,n|
      diagonal = []
      x = coords.first; y = coords.last
      while width.include?(x) && length.include?(y)
        x -= m; y -= n
      end
      x += m; y += n
      while width.include?(x) && length.include?(y)
        diagonal << square(x,y)
        x += m; y += n
      end
      diagonals << diagonal unless diagonal.size == 1
    end
    diagonals
  end
  
  def same_row?(*squares)
    squares.map! { |sq| format_coords(sq) }
    squares.all? { |_,y| y == squares.first[1] }
  end
  
  def same_col?(*squares)
    squares.map! { |sq| format_coords(sq) }
    squares.all? { |x,_| x == squares.first[0] }
  end
  
  alias :same_column? :same_col?
  
  def same_diagonal?(*squares)
    squares.map! { |sq| square(sq) }
    diagonals(squares.first).any? do |diagonal|
      squares.all? { |square| diagonal.include?(square) }
    end
  end
  
  #TODO: there should be methods to flip the entire board, not only the values
  #TODO: add a rotate method
  def flip!(axis = :x)
    raise ArgumentError unless [:x, :y].include?(axis.to_sym)
    send("flip_#{axis}!")
  end
  
  def flip_x!
    (0...grid.first.size).each do |m|
      (0...grid.size / 2).each do |n|
        sq1 = grid[n][m]
        sq2 = grid[(grid.size - 1) - n][m]
        sq1.value, sq2.value = sq2.value, sq1.value
      end
    end
    self
  end
  
  def flip_y!
    (0...grid.first.size / 2).each do |m|
      (0...grid.size).each do |n|
        sq1 = grid[n][m]
        sq2 = grid[n][(grid.first.size - 1) - m]
        sq1.value, sq2.value = sq2.value, sq1.value
      end
    end
    self
  end
  
  def flip(axis = :x)
    raise ArgumentError unless [:x, :y].include?(axis.to_sym)
    flip!(axis)
    board = Board.new(grid.first.size, grid.size) { |x,y| square(x,y).value }
    flip!(axis)
    board
  end
  
  def flip_x
    flip(:x)
  end
  
  def flip_y
    flip(:y)
  end
  
  #The each method iterates over the board starting from the bottom left
  #square to the top right square.
  def each
    if block_given?
      grid.reverse_each { |row| row.each { |square| yield(square) } }
    else
      Enumerator.new do |y|
        grid.reverse_each { |row| row.each { |square| y << square } }
      end
    end
  end

  def to_s
    grid.map do |row|
      row.map { |square| square.value }.join(' ')
    end.join("\n")
  end
  
  def [](idx)
    grid[idx]
  end
  
  def index(coords)
    x,y = format_coords(coords)
    [grid.size - y, x - 1]
  end
  
  private
  
  #write tests for this method
  #any method that uses the format_coords method can also accept Square objects
  def format_coords(coords)
    format_coords_into_array(coords).map do |c|
      raise ArgumentError unless c.to_s =~ /[0-9a-zA-Z]/
      ord = c.ord
      if c.is_a? Integer
        c
      else
        c =~ /[a-zA-Z]/ ? c =~ /[a-z]/ ? ord - 96 : ord - 64 : c.to_i
      end
    end
  end
  
  def format_coords_into_array(coords)
    coords = coords.first if coords.is_a?(Array) && coords.size == 1
    coords = coords.coords if coords.is_a?(Square)
    coords = coords.chars if coords.is_a?(String)
    unless coords.size == 2
      raise ArgumentError, "Expected an 'x' and a 'y' coordinate."
    end
    coords
  end
end