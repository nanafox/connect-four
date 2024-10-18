# frozen_string_literal: true

require_relative "../lib/player"

RSpec.describe Player do
  subject(:player) { described_class.new(name: "John", symbol: "X") }

  describe "#initialize" do
    it "has the player's name" do
      expect(player.name).not_to be_nil
      expect(player.name).to eql("John")
    end

    it "has the player's symbol" do
      expect(player.symbol).not_to be_nil
      expect(player.symbol).to eql("X")
    end
  end

  describe "player creation" do
    it "creates a new player" do
      player = Player.new(name: "Sally", symbol: "X")

      expect(player).to be_a(Player)
    end
  end
end
