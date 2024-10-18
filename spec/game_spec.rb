# frozen_string_literal: true

require_relative "../lib/game"
require_relative "../lib/board"
require_relative "../lib/player"

RSpec.describe Game do
  let(:player_class) { class_double(Player) }

  subject(:game) do
    described_class.new(player_class:)
  end

  let(:player_x) { instance_double(Player, name: "John", symbol: "X") }
  let(:player_o) { instance_double(Player, name: "Sally", symbol: "O") }

  before do
    allow(game).to receive(:print)
    allow(game).to receive(:puts)
    allow(game).to receive(:gets).and_return("John", "Sally")

    allow(player_class).to receive(:new).with(name: "John", symbol: "X")
                                        .and_return(player_x)

    allow(player_class).to receive(:new).with(name: "Sally", symbol: "O")
                                        .and_return(player_o)
    allow(game).to receive(:exit)
  end

  describe "#create_players" do
    it "returns two players" do
      players = game.create_players

      expect(players).to contain_exactly(player_x, player_o)
    end

    it "creates players with a name and a symbol using the player_class" do
      players = game.create_players

      expect(players).to match_array(
        [
          have_attributes(name: "John", symbol: "X"),
          have_attributes(name: "Sally", symbol: "O")
        ]
      )
    end

    it "calls the player_class to create players" do
      game.create_players

      expect(player_class).to have_received(:new).with(
        name: "John", symbol: "X"
      )
      expect(player_class).to have_received(:new).with(
        name: "Sally", symbol: "O"
      )
    end

    context "when a specific symbol is given for the players" do
      let(:symbols) { %W[\u2600 \u260c] }
      let(:player_x_with_unicode) do
        instance_double("Player", name: "John", symbol: symbols[0])
      end
      let(:player_o_with_unicode) do
        instance_double("Player", name: "Sally", symbol: symbols[1])
      end

      before do
        allow(player_class).to receive(:new).with(
          name: "John", symbol: symbols[0]
        ).and_return(player_x_with_unicode)

        allow(player_class).to receive(:new).with(
          name: "Sally",
          symbol: symbols[1]
        ).and_return(player_o_with_unicode)
      end

      it "calls the player class with the given symbols" do
        game.create_players(symbols)

        expect(player_class).to have_received(:new).with(
          name: "John", symbol: symbols[0]
        )
        expect(player_class).to have_received(:new).with(
          name: "Sally", symbol: symbols[1]
        )
      end

      it "creates players with a the given symbols" do
        players = game.create_players(symbols)

        expect(players).to match_array(
          [
            have_attributes(name: "John", symbol: symbols[0]),
            have_attributes(name: "Sally", symbol: symbols[1])
          ]
        )
      end
    end

    context "when no name is given for the player" do
      it "fails and returns nil for both users" do
        allow(game).to receive(:gets).and_return("", "")

        players = game.create_players

        expect(players).to contain_exactly(nil, nil)
      end
    end
  end

  describe "#play" do
    before do
      allow(game).to receive(:create_players).and_call_original
      allow(game).to receive(:create_board).and_call_original
      allow(game).to receive(:update_move_for).and_call_original
      allow(game).to receive(:gets).and_return(
        "John", "Sally", "1", "2", "3", "4"
      )
      allow(game).to receive(:over?).and_return(true)
    end

    it "creates two players" do
      game.play

      expect(game.player_x).to eq(player_x)
      expect(game.player_o).to eq(player_o)
      expect(game).to have_received(:create_players)
    end

    context "when the player creation fails" do
      let(:expected_error_message) do
        "Expected two players to play. Try Again!".colorize(:red)
      end

      before do
        allow(game).to receive(:warn).with(expected_error_message)
                                     .and_call_original
        allow(game).to receive(:create_players).and_return(nil, nil)
        allow(game).to receive(:exit).with(1).once
      end

      it "exits the game" do
        game.play

        expect(game).to have_received(:exit).with(1)
      end

      it "prints a descriptive message why it exited" do
        expect do
          game.play
        end.to output("#{expected_error_message}\n").to_stderr

        expect(game).to have_received(:exit).with(1)
      end
    end

    it "creates the game board" do
      game.play

      expect(game.board).not_to be_nil
    end

    context "when the game is over after a move" do
      before do
        allow(game).to receive(:over?).and_return(false, true)
      end

      it "breaks the loop and ends the game" do
        game.play

        expect(game).to have_received(:over?).twice
      end
    end

    context "when the game is not over after a move" do
      before do
        allow(game).to receive(:over?).and_return(false, false, true)
      end

      it "continues the game until it is over" do
        game.play

        expect(game).to have_received(:over?).exactly(3).times
      end
    end

    context "when the game is over and the winner is X" do
      before do
        game.create_board

        allow(game.board).to receive(:win?).and_return(true)
        allow(game).to receive(:winner).and_return(player_x)
        allow(game).to receive(:over?).and_return(true)
      end

      it "sets the winner to the right person (last user to move)" do
        game.play

        expect(game.winner).to eql(player_x)
      end
    end

    context "when the game is over and the winner is O" do
      before do
        game.create_board

        allow(game.board).to receive(:win?).and_return(true)
        allow(game).to receive(:winner).and_return(player_o)
        allow(game).to receive(:over?).and_return(true)
      end

      it "sets the winner to the right person (last user to move)" do
        game.play

        expect(game.winner).to eql(player_o)
      end
    end

    context "when the game is over and not winner is found" do
      before do
        game.create_board

        allow(game.board).to receive(:win?).and_return(false)
        allow(game).to receive(:over?).and_return(true)
      end

      it "sets the winner field to nil" do
        game.play

        expect(game.winner).to be_nil
      end
    end
  end

  describe "#create_board" do
    let(:game_board) { instance_double(Board) }

    it "creates a new board for the game" do
      board = game.create_board

      expect(board).not_to be_nil
    end

    it "ensures the board responds to #win? command" do
      allow(game_board).to receive(:win?)

      expect(game_board).to respond_to(:win?)
      game.create_board
    end
  end

  describe "#over?" do
    let(:game_board) { game.board }

    before do
      allow(game).to receive(:create_board).and_call_original

      game.create_board
    end

    context "when a winner is found and the board is not full" do
      it "returns true" do
        allow(game_board).to receive(:win?).and_return(true)
        allow(game_board).to receive(:full?).and_return(false)

        expect(game.over?).to be(true)
      end
    end

    context "when the board is full and no winner is found" do
      it "returns true" do
        allow(game_board).to receive(:win?).and_return(false)
        allow(game_board).to receive(:full?).and_return(true)

        expect(game.over?).to be(true)
      end
    end

    context "when the board is full and the winner is found" do
      it "returns true" do
        allow(game_board).to receive(:win?).and_return(true)
        allow(game_board).to receive(:full?).and_return(true)

        expect(game.over?).to be(true)
      end
    end

    context "when the board is not full and no winner found yet" do
      it "returns false" do
        allow(game_board).to receive(:win?).and_return(false)
        allow(game_board).to receive(:full?).and_return(false)

        expect(game.over?).to be(false)
      end
    end
  end

  describe "#update_move_for" do
    let(:game_board) { game.board }
    let(:player_x) { instance_double(Player, name: "John", symbol: "X") }
    let(:player_o) { instance_double(Player, name: "Sally", symbol: "O") }

    before do
      allow(game).to receive(:player_x).and_return(player_x)
      allow(game).to receive(:player_o).and_return(player_o)

      game.create_board
      game.create_players
    end

    context "when a move is made for player X" do
      before do
        allow(game).to receive(:gets).and_return("1")
        allow(game_board).to receive(:update).with(1, "X").and_return(true)
      end

      it "updates the board with the player's symbol at the right position" do
        response = game.update_move_for(player_x)
        expect(response).to be(true)

        expect(game_board).to have_received(:update).with(1, "X")
      end
    end

    context "when a move is made for player O" do
      before do
        allow(game).to receive(:gets).and_return("2")
        allow(game_board).to receive(:update).with(2, "O").and_return(true)
      end

      it "updates the board with the player's symbol at the right position" do
        response = game.update_move_for(player_o)

        expect(response).to be(true)
        expect(game_board).to have_received(:update).with(2, "O")
      end
    end

    context "when the update fails because of wrong input" do
      before do
        allow(game).to receive(:gets).and_return("100", "2")
        allow(game_board).to receive(:update).with(100, "O").and_return(false)
        allow(game_board).to receive(:update).with(2, "O").and_return(true)
        allow(game).to receive(:update_move_for).and_call_original
      end

      it "retries for the same player" do
        game.update_move_for(player_o)

        expect(game_board).to have_received(:update).twice
        expect(game_board).to have_received(:update).with(100, "O")
        expect(game_board).to have_received(:update).with(2, "O")
      end

      it "prints an error message" do
        expected_error_message = "Enter a valid column number.".colorize(:red)
        expect do
          game.update_move_for(player_o)
        end.to output("#{expected_error_message}\n").to_stderr
      end
    end

    context "when the input is not a number" do
      let(:bad_input) { "bad_input" }
      before do
        allow(game).to receive(:gets).and_return(bad_input, "2")
        allow(game_board).to receive(:update).with(bad_input, "O")
                                             .and_return(false)
        allow(game_board).to receive(:update).with(2, "O").and_return(true)
        allow(game).to receive(:update_move_for).and_call_original
      end

      it "prints an error message" do
        msg = "Invalid input. Please enter a valid column number."

        expect do
          game.update_move_for(player_o)
        end.to output("#{msg.colorize(:red)}\n").to_stderr
      end
    end
  end
end
