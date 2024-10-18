# frozen_string_literal: true

require "colorize"
require_relative "player"
require_relative "board"

# Game class handles the main game logic, including player creation,
# move handling, and game state checking.
class Game
  attr_reader :player_x, :player_o, :board, :winner

  # Initializes a new Game instance.
  # @param player_class [Class] the class to use for creating players.
  def initialize(player_class: Player)
    @player_class = player_class
  end

  # Starts the game by creating players, verifying
  # them, creating the board, and handling moves.
  def play
    @player_x, @player_o = create_players
    return unless verify_players

    create_board

    handle_moves
  end

  # Updates the move for the given player.
  # @param player [Player] the player making the move.
  def update_move_for(player)
    @winner = player

    loop do
      puts "#{player.name}'s move. Symbol: #{player.symbol}"

      print("Enter the column to insert[0 - #{@board.length}]: ~> ")
      move = gets.chomp

      begin
        column = Integer(move)
        response = @board.update(column, player.symbol)
        return response if response

        warn("Enter a valid column number.".colorize(:red))
      rescue ArgumentError
        warn "Invalid input. Please enter a valid column number.".colorize(:red)
      end
    end
  end

  # Checks if the game is over.
  # @return [Boolean] true if the game is over, false otherwise.
  def over?
    @board.win? || @board.full?
  end

  # Creates players for the game.
  # @param symbols [Array<String>] an array of symbols for the players.
  # @return [Array<Player>, Array<nil>] an array of created players or nil
  #   if a name is empty.
  def create_players(symbols = %w[X O])
    players = []

    symbols.each do |symbol|
      print "#{symbol}: Player Name: ~> "
      name = gets.chomp

      return nil, nil if name.empty?

      players << @player_class.new(name:, symbol:)
    end

    players
  end

  # Creates the game board.
  # @param board_class [Class] the class to use for creating the board.
  def create_board(board_class = Board)
    @board = board_class.new
  end

  private

    # Verifies that two players have been created.
    # @return [Boolean] true if two players are created, false otherwise.
    def verify_players
      if @player_x && @player_o
        true
      else
        warn "Expected two players to play. Try Again!".colorize(:red)
        exit(1)
      end
    end

    # Handles the moves for both players until the game is over.
    def handle_moves
      loop do
        update_move_for(@player_x)
        display_board
        break if over?

        update_move_for(@player_o)
        display_board
        break if over?
      end

      announce_winner
    end

    # Displays the current state of the board.
    def display_board
      system("cls") || system("clear")
      board.display
    end

    # Announces the winner of the game.
    def announce_winner
      if @board.win?
        puts "Congratulations #{@winner.name}, you won!"
      else
        @winner = nil
        puts "It was tie"
      end
    end
end
