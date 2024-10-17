# frozen_string_literal: true

# Class for game player
class Player
  attr_reader :name, :symbol

  # Initialize a player object.
  def initialize(name:, symbol:)
    @name = name
    @symbol = symbol
  end
end
