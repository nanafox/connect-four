# frozen_string_literal: true

require_relative "../lib/board"

# rubocop:disable Metrics/BlockLength

RSpec.describe Board do
  subject(:board) { described_class.new }
  let(:player_one) { double("player", symbol: "X") }
  let(:player_two) { double("player", symbol: "O") }
  let(:columns) { Board::COLUMNS }
  let(:rows) { Board::ROWS }

  describe "#initialize" do
    it "creates an Array" do
      expect(board.grid).to be_an(Array)
    end

    it "creates an array of of 7 x 6 structure" do
      expect(board.grid.length).to eql(6)
      board.grid.each { |row| expect(row.length).to eql(7) }
    end
  end

  describe "#update" do
    context "when the slot is empty and one move is made" do
      it "updates the board with the move" do
        move_col = 4
        board.update(move_col, player_one.symbol)

        expect(board.grid[0][move_col - 1]).to eql(player_one.symbol)
      end
    end

    context "when a column is empty and six moves are played on it" do
      it "updates all six rows in the column with the move accordingly" do
        move = 4

        rows.times do |index|
          symbol = [player_one.symbol, player_two.symbol].sample

          board.update(move, symbol)

          expect(board.grid[index][move - 1]).to eql(symbol)
        end
      end
    end
    context "when a column is filled and not updatable" do
      let(:move) { 4 }
      before do
        rows.times do
          symbol = [player_one.symbol, player_two.symbol].sample
          board.update(move, symbol)
        end
      end

      it "does not update the board" do
        expect(board.update(move, "O")).to be(false)
      end
    end

    context "when the column given is out of range" do
      it "does not update the board" do
        out_of_range_column = board.length + 1
        expect(board.update(out_of_range_column, "X")).to be(false)
      end
    end
  end

  describe "#updatable?" do
    let(:move) { 4 }

    it "returns true when the slot has an empty spot" do
      allow(board).to receive(:updatable?).with(move).and_return(true)

      expect(board.updatable?(move)).to be(true)
    end

    it "returns false when there's no available slot for the intended" do
      allow(board).to receive(:updatable?).with(move).and_return(false)

      expect(board.updatable?(move)).to be(false)
    end
  end

  describe "#full?" do
    context "when all the slots are filled" do
      before do
        board.grid.each do |row|
          row.length.times do |index|
            row[index] = %w[X O].sample
          end
        end
      end

      it "returns true" do
        expect(board).to be_full
      end
    end

    context "when there are available slots" do
      before do
        board.update(4, "X")
        board.update(3, "O")
        board.update(5, "X")
        board.update(1, "O")
      end

      it "returns false" do
        expect(board).not_to be_full
      end
    end
  end

  describe "#win?" do
    context "when there is a horizontal win" do
      it "returns true" do
        4.times { |i| board.update(i + 1, player_one.symbol) }
        expect(board.win?).to be true
      end
    end

    context "when there is a vertical win" do
      it "returns true" do
        4.times { board.update(1, player_one.symbol) }
        expect(board.win?).to be true
      end
    end

    context "when there is a diagonal win (left-to-right)" do
      it "returns true" do
        board.update(1, player_one.symbol)
        board.update(2, player_two.symbol)
        board.update(2, player_one.symbol)
        board.update(3, player_one.symbol)
        board.update(3, player_two.symbol)
        board.update(3, player_one.symbol)
        board.update(4, player_two.symbol)
        board.update(4, player_one.symbol)
        board.update(4, player_two.symbol)
        board.update(4, player_one.symbol)

        expect(board.win?).to be true
      end
    end

    context "when there is a diagonal win (right-to-left)" do
      it "returns true" do
        board.update(4, player_one.symbol)
        board.update(3, player_two.symbol)
        board.update(3, player_one.symbol)
        board.update(2, player_two.symbol)
        board.update(2, player_two.symbol)
        board.update(2, player_one.symbol)
        board.update(1, player_two.symbol)
        board.update(1, player_two.symbol)
        board.update(1, player_two.symbol)
        board.update(1, player_one.symbol)

        expect(board.win?).to be true
      end
    end

    context "when there is no win" do
      it "returns false" do
        board.update(4, player_one.symbol)
        board.update(3, player_two.symbol)
        board.update(3, player_one.symbol)
        board.update(2, player_two.symbol)

        expect(board.win?).to be(false)
      end
    end
  end

  describe "#display" do
    context "when the board is empty" do
      let(:expected_output) do
        <<~BOARD
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
        BOARD
      end

      it "displays the empty board" do
        expect { board.display }.to output(expected_output).to_stdout
      end
    end

    context "when the board is not empty" do
      before do
        board.update(2, "X")
        board.update(3, "O")
        board.update(4, "O")
        board.update(4, "X")
        board.update(7, "O")
      end

      let(:expected_output) do
        <<~BOARD
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   |   |   |   |   |
          +---+---+---+---+---+---+---+
          |   |   |   | X |   |   |   |
          +---+---+---+---+---+---+---+
          |   | X | O | O |   |   | O |
          +---+---+---+---+---+---+---+
        BOARD
      end

      it "displays the board with the moves at the correct positions" do
        expect { board.display }.to output(expected_output).to_stdout
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
