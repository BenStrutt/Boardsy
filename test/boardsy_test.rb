require "test_helper"

class BoardsyTest < Minitest::Test
  def setup
    @board = Board.new(8)
  end
  
  def test_that_it_has_a_version_number
    refute_nil ::Boardsy::VERSION
  end
  
  # Board::new method tests
  
  def test_board_initializtion_with_one_argument_no_block
    assert_equal @board.rows, 8
    assert_equal @board.cols, 8
    assert @board.all? { |square| square.value == nil }
  end
  
  def test_board_initializtion_with_two_arguments_no_block
    board = Board.new(8, 5)
    assert_equal board.rows, 5
    assert_equal board.cols, 8
    assert board.all? { |square| square.value == nil }
  end
  
  def test_board_initializtion_with_three_arguments_no_block
    board = Board.new(8, 5, value: 'test')
    assert_equal board.rows, 5
    assert_equal board.cols, 8
    assert board.all? { |square| square.value == 'test' }
  end
  
  def test_board_initializtion_with_one_argument_with_block
    board = Board.new(8) { |x,y| [x,y] } 
    assert_equal board.rows, 8
    assert_equal board.cols, 8
    coords = [4,6]
    assert_equal board[2][3].value, coords
  end
  
  def test_board_initializtion_with_two_arguments_with_block
    board = Board.new(8, 5) { |x,y| [x,y] } 
    assert_equal board.rows, 5
    assert_equal board.cols, 8
    coords = [4,3]
    assert_equal board[2][3].value, coords
  end
  
  def test_board_initializtion_with_three_arguments_with_block
    board = Board.new(8, 5, value: 'test') { |_,_,val| val } 
    assert_equal board.rows, 5
    assert_equal board.cols, 8
    assert board.all? { |square| square.value == 'test' }
  end
  
  # Board::square method tests

  def test_that_square_method_accepts_integer_args
    x,y = [*1..8].sample,[*1..8].sample
    board = square_method_test_board
    assert board.square(x,y).is_a?(Square)
    assert board.square(4, 6).value
  end
  
  def test_that_square_method_accepts_string_args
    board = square_method_test_board
    x,y = [*'1'..'8'].sample,[*'1'..'8'].sample
    assert board.square(x,y).is_a?(Square)
    assert board.square('4', '6').value
  end
  
  def test_that_square_method_accepts_algebraic_notation_args
    board = square_method_test_board
    x,y = [*'a'..'h'].sample,[*1..8].sample 
    assert board.square(x,y).is_a?(Square)
    assert board.square('d', 6).value
  end
  
  def test_that_square_method_accepts_algebraic_notation_with_string_args
    board = square_method_test_board
    x,y = [*'a'..'h'].sample,[*'1'..'8'].sample 
    assert board.square(x,y).is_a?(Square)
    assert board.square('d', '6').value
  end
  
  def test_that_square_method_accepts_integer_array
    board = square_method_test_board
    x,y = [*1..8].sample,[*1..8].sample
    assert board.square([x,y]).is_a?(Square)
    assert board.square([4,6]).value
  end
  
  def test_that_square_method_accepts_string_array
    board = square_method_test_board
    x,y = [*'1'..'8'].sample,[*'1'..'8'].sample
    assert board.square([x,y]).is_a?(Square)
    assert board.square(['4','6']).value
  end
  
  def test_that_square_method_accepts_algebraic_notation_array
    board = square_method_test_board
    x,y = [*'a'..'h'].sample,[*1..8].sample
    assert board.square([x,y]).is_a?(Square)
    assert board.square(['d',6]).value
  end
  
  def test_that_square_method_accepts_algebraic_notation_array_with_string_args
    board = square_method_test_board
    x,y = [*'a'..'h'].sample,[*'1'..'8'].sample 
    assert board.square([x,y]).is_a?(Square)
    assert board.square(['d','6']).value
  end
  
  # Board::row, Board::col tests
  
  def test_row_of_a_tile_with_coords_passed
    squares = (1..8).map { |n| @board.square(n,3) }
    assert_equal @board.row('f3'), squares
  end
  
  def test_row_of_a_tile_with_square_object_passed
    squares = (1..8).map { |n| @board.square(n,3) }
    square = @board.square('f3')
    assert_equal @board.row(square), squares
  end
  
  def test_col_of_a_tile_with_coords_passed
    squares = (1..8).map { |n| @board.square(3,n) }
    assert_equal @board.col('c6'), squares
  end
  
  def test_col_of_a_tile_with_square_object_passed
    squares = (1..8).map { |n| @board.square(3,n) }
    square = @board.square('c6')
    assert_equal @board.col(square), squares
  end
  
  # Board::same? method tests
  
  #TODO: WRITE REFUTATION TESTS
  
  def test_same_row_two_squares
    assert @board.same_row?('a1', 'g1')
  end
  
  def test_same_row_multiple_squares
    assert @board.same_row?('a2', 'c2', 'g2', 'e2')
  end
  
  def test_that_same_row_method_takes_square_objects
    sq1 = @board.square('a3')
    sq2 = @board.square('e3')
    assert [sq1, sq2].all? { |sq| sq.is_a?(Square) }
    assert @board.same_row?(sq1, sq2)
  end
  
  def test_same_column_two_squares
    assert @board.same_col?('a1', 'a7')
  end
  
  def test_same_column_multiple_squares
    assert @board.same_col?('d1', 'd7', 'd5', 'd4')
  end
  
  def test_that_same_col_method_takes_square_objects
    sq1 = @board.square('f3')
    sq2 = @board.square('f7')
    assert [sq1, sq2].all? { |sq| sq.is_a?(Square) }
    assert @board.same_col?(sq1, sq2)
  end
  
  def test_same_diagonal_two_squares
    assert @board.same_diagonal?('a1', 'd4')
  end
  
  def test_same_row_multiple_squares
    assert @board.same_diagonal?('g1', 'e3', 'c5', 'a7')
  end
  
  def test_that_same_row_method_takes_square_objects
    sq1 = @board.square('a3')
    sq2 = @board.square('e7')
    assert [sq1, sq2].all? { |sq| sq.is_a?(Square) }
    assert @board.same_diagonal?(sq1, sq2)
  end
  
  # Board::same? method tests
  
  def test_non_mutating_flip_on_x_axis
    board = Board.new(3,5) { false }
    board.square('a1').value = true
    board.square('c5').value = true
    flipped_board = board.flip(:x)
    assert ['a1','c5'].all? { |coord| board.square(coord).value }
    assert ['a5','c1'].all? { |coord| flipped_board.square(coord).value }
    false_squares = flipped_board.squares.reject { |sq| sq }
    assert false_squares.all? { false }
  end
  
  def test_non_mutating_flip_on_y_axis
    board = Board.new(5,4) { false }
    board.square('a3').value = true
    board.square('d1').value = true
    flipped_board = board.flip('y')
    assert ['a3','d1'].all? { |coord| board.square(coord).value }
    assert ['e3','b1'].all? { |coord| flipped_board.square(coord).value }
    false_squares = flipped_board.squares.reject { |sq| sq }
    assert false_squares.all? { false }
  end
  
  def test_mutating_flip_on_x_axis
    board = Board.new(8) { false }
    board.square('d4').value = true
    board.square('f3').value = true
    board.flip!('x')
    assert ['d5','f6'].all? { |coord| board.square(coord).value }
    false_squares = board.squares.reject { |sq| sq }
    assert false_squares.all? { false }
  end
  
  def test_mutating_flip_on_y_axis
    board = Board.new(8) { false }
    board.square('h7').value = true
    board.square('c5').value = true
    board.flip!(:y)
    assert ['a7','f5'].all? { |coord| board.square(coord).value }
    false_squares = board.squares.reject { |sq| sq }
    assert false_squares.all? { false }
  end
  
  # Enumerable module tests
  
  def test_that_the_each_method_iterates_properly
    x,y = 1,1
    board = Board.new(4)
    board.each do |square|
      assert_equal square.coords, [x,y]
      x += 1; if x == 5; x = 1; y += 1; end
    end
  end
  
  def test_the_select_method
    board = Board.new(8)
    board.square(2, 7).value = 'test'
    square = board.select { |square| square.value == 'test' }
    assert_equal square.size, 1
    assert_equal square.first.value, 'test'
  end
  
  private

  def square_method_test_board
    board = Board.new(8)
    board[2][3].value = true
    board
  end
end
