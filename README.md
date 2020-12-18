# Boardsy

This gem provides a `Board` class to build Command Line Interface board games in Ruby. See the "Usage" section below for available methods.
This project is actively being worked on. Additional functionality will be added on a consistent basis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boardsy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install boardsy

## Usage

The board is stored by the class as a 2D array of `Square` objects.
Each `Square` object contains a value and its x and y coordinates within the board.
By default, each `Square` object is initialized with its value set to `nil`.

### Initialization

The board is initialized as an 8x8 board by default.

```ruby
Board.new # returns a Board object of 8x8 Square objects
```

The length and width can be specified by passing a single argument.

```ruby
Board.new(4) # returns a Board object of 4x4 Square objects
```

The length and width can be individually specified by passing an 'x' value and a 'y' value as arguments.

```ruby
Board.new(6,8) # returns a Board object of 6x8 Square objects
```

A `value` argument can be passed to initialize each `Square` object with the value passed.

```ruby
Board.new(6, 8, value: 'empty')
```

In addition, a block can be passed to `Board#new` to assign a value to each `Square` object.

```ruby
Board.new(4) { |x,y| (x.odd? && y.odd?) ? 'X' : 'O' } # returns a Board object laid out as the following:
#|O|O|O|O|
#|X|O|X|O|
#|O|O|O|O|
#|X|O|X|O|
```

### Enumerable methods

The `Board` class includes the `Enumerable` module, and has access to each method provided `Enumerable`.
The squares of the board are passed row by row starting from the bottom left-square and ending with the upper-right square.
Calling `Board#each` without passing a block will return an `Enumerable` object.

### Methods for retrieving information about the board

`Board#length` returns the length of the board as an integer.
`Board#width` returns the width of the board as an integer.

```ruby
board = Board.new(5,8)
board.length # 5
board.width # 8
```

`Board#squares` will return an array of each `Square` object, in the order that they are iterated by `Board#each`

```ruby
board = Board.new(2)
board.squares.map { |sq| sq.coords } # [[1,1], [2,1], [1,2], [2,2]]
```

### Methods for selecting portions of the board.

`Board#square` returns the `Square` object as specified by the coordinates passed as an argument.
The 'x' and 'y' coordinates can be passed as individual arguments, an `[x,y]` array, or an `'xy'` string.
The coordinates can additionally be passed an algebraic format, as done in chess: `'d4'`, `['d',5]`.
This also applies to any following method that takes coordinates as an argument.

```ruby
board = Board.new
board.square(4,4)
board.square([7,2])
board.square('a5')
```

`Board#row` returns the row, from left to right as an array, in which the given square is located.
`Board#col` or `Board#column` returns the column, from bottom to top as an array, in which the given square is located.
Both methods will accept a `Square` object as an argument as well as coordinates formatted in the same way as `Board#square`.

```ruby
board = Board.new
board.row(5,8) # returns an array of the squares in the top row
board.col('a7') # returns an array of the squares in the left-most column

square = board.square(['h',4])
board.col(square) # returns an array of the squares in the right-most column
```

`Board#diagonals` returns a 2D array where each nested array is an array of squares along a diagonal which intersects the passed coordinates.
This method accepts the same argument formats as `Board#row` and `Board#col`.

```ruby
board = Board.new(4)
diagonals = board.diagonals(2,2)
diagonals.each { |diagonal| p diagonal.map { |sq| sq.coords } }
=> [[1,1], [2,2], [3,3], [4,4]]
=> [[1,3], [2,2], [3,1]]
```

The standard `[]` notation can be used to select an array of squares by standard indexing.

```ruby
board = Board.new(8)
square = board[0][3]
square.coords # [4,8]
```

The `Board#index` method can be used to retrieve the indexes of a square within the 2D array that the board is represented in.

```ruby
board = Board.new(4)
board.index([3,3]) # [1,2]
board[1][2] # [3,3]
```

### Testing the relationship between squares

Each of the following methods accepts an array of coordinates or an array of `Square` objects as an argument and returns a boolean value.
`Board#same_row?`, `Board#same_col?` (alias: `Board#same_column?`), `Board#same_diagonal?`.

```ruby
board = Board.new
board.same_row?('a4', 'd4', 'g4') # true
board.same_col?([3,2], [3,7], [2,5]) # false

sq1 = board.square('a1')
sq2 = board.square('d4')
board.same_diagonal?(sq1,sq2) # true
```

### Altering the orientation of the board

The `Board` class provides methods for flipping the board.
At the moment, these methods will only flip the values of the squares along the given axis. The coordinates of the squares will stay the same. Methods allowing 'hard' flips will be added soon.
Methods succeeded by a '!' will mutate the `Board` object itself. Methods without the exclamation mark will leave the original `Board` object and return a new `Board` object.
The current available methods are `flip`, `flip!`, `flip_x`, `flip_y`, `flip_x!`, and `flip_y!`.
`flip` and `flip!` take as an argument the axis as either a string or a symbol. By default they flip along the x axis.

```ruby
board = Board.new(3, value: 'O')
board.square([1,2]).value = 'X'
board.square([3,3]).value = 'X'
board_x = board.flip(:x)
board_y = board.flip('y')

board # returns the following Board object:
# |O|O|X|
# |X|O|O|
# |O|O|O|

board_x # returns the following Board object:
# |O|O|O|
# |X|O|O|
# |O|O|X|

board_y # returns the following Board object:
# |X|O|O|
# |O|O|X|
# |O|O|O|

board.flip!('x')
board.flip!(:y)

board # now returns the following Board object:
# |O|O|O|
# |O|O|X|
# |X|O|O|
```

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/boardsy/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Boardsy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/boardsy/blob/master/CODE_OF_CONDUCT.md).
