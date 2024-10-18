# frozen_string_literal: true

# The Board class represents a Connect Four game board.
# It provides methods to update the board, check for wins, and display the
# board.
class Board
  ROWS = 6
  COLUMNS = 7
  EMPTY_SLOT = nil
  attr_reader :grid

  # Initializes a new Board instance.
  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS, EMPTY_SLOT) }
    @next_available_row = Array.new(COLUMNS, 0)
  end

  # Updates the board with a move.
  #
  # @param column [Integer] The column where the move is made (1-based index).
  # @param symbol [Object] The symbol representing the player making the move.
  # @return [Boolean] `true` on successful updates, `false` otherwise
  def update(column, symbol)
    return false if symbol.nil? || column > COLUMNS

    array_column = column - 1
    return false unless updatable?(array_column)

    row = @next_available_row[array_column]
    @grid[row][array_column] = symbol
    @next_available_row[array_column] += 1

    true
  end

  # Checks if the current column can be updated with a move.
  #
  # @param column [Integer] The specific column this move is going to.
  # @return [Boolean] `true` if there is a free space, `false` otherwise.
  def updatable?(column)
    return false unless column <= COLUMNS

    spot = @next_available_row[column]
    spot < ROWS && @grid[spot][column].nil?
  end

  # Checks if the board has been filled up completely.
  #
  # @note It is a tie when the board is full and there is no winner after
  #   a final check is made.
  # @return [Boolean] `true` if the board is full, `false` otherwise.
  def full?
    grid.flatten.all?
  end

  # Checks if there is a winning combination on the board.
  #
  # @return [Boolean] `true` if there is a win, `false` otherwise.
  def win?
    horizontal_win? || vertical_win? || diagonal_win?
  end

  # Displays the board in the console.
  def display
    puts self
  end

  # Converts the board to a string representation.
  #
  # @return [String] The string representation of the board.
  def to_s
    space = 3
    separator = "#{'+---' * COLUMNS}+\n"
    column_numbers = (1..COLUMNS).map do |num|
      num.to_s.center(space)
    end.join(" ").rstrip

    # Start with column numbers at the top
    board_str = " #{column_numbers}\n" + separator.dup

    # Print from the bottom row to the top row
    (@grid.length - 1).downto(0) do |i|
      row_str = @grid[i].map { |cell| cell.to_s.center(space) }.join("|")
      board_str << "|#{row_str}|\n" << separator
    end

    board_str
  end

  # Returns the length of the column in the board
  def length
    @grid[0].length
  end

  private

    # Checks for a horizontal win on the board.
    #
    # @return [Boolean] `true` if there is a horizontal win, `false` otherwise.
    def horizontal_win?
      grid.any? do |row|
        row.each_cons(4).any? do |four_in_a_row|
          winning_combination?(four_in_a_row)
        end
      end
    end

    # Checks for a vertical win on the board.
    #
    # @return [Boolean] `true` if there is a vertical win, `false` otherwise.
    def vertical_win?
      (0...COLUMNS).any? do |col|
        column = grid.map { |row| row[col] }
        column.each_cons(4).any? do |four_in_a_column|
          winning_combination?(four_in_a_column)
        end
      end
    end

    # Checks for a diagonal win on the board.
    #
    # @return [Boolean] `true` if there is a diagonal win, `false` otherwise.
    def diagonal_win?
      left_to_right_diagonal_win? || right_to_left_diagonal_win?
    end

    # Checks for a left-to-right diagonal win on the board.
    #
    # @return [Boolean] `true` if there is a left-to-right diagonal win,
    #   `false` otherwise.
    def left_to_right_diagonal_win?
      (0..ROWS - 4).each do |row|
        (0..COLUMNS - 4).each do |col|
          diagonal = (0..3).map do |i|
            value = @grid[row + i][col + i]
            value
          end

          return true if winning_combination?(diagonal)
        end
      end
      false
    end

    # Checks for a right-to-left diagonal win on the board.
    #
    # @return [Boolean] `true` if there is a right-to-left diagonal win,
    #   `false` otherwise.
    def right_to_left_diagonal_win?
      (0..ROWS - 4).each do |row|
        (3...COLUMNS).each do |col|
          diagonal = (0..3).map do |i|
            value = @grid[row + i][col - i]
            value
          end

          return true if winning_combination?(diagonal)
        end
      end
      false
    end

    # Checks if a given combination of four cells is a winning combination.
    #
    # @param combination [Array] The combination of four cells to check.
    # @return [Boolean] `true` if the combination is a winning combination,
    #   `false` otherwise.
    def winning_combination?(combination)
      combination.uniq.size == 1 && combination.first != EMPTY_SLOT
    end
end
