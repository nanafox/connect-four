# Connect Four - Ruby CLI Game

```text
  CCCC   OOO   N   N  N   N  EEEEE  CCCC  TTTTT     FFFFF  OOO  U   U  RRRR  
 C      O   O  NN  N  NN  N  E     C        T       F     O   O U   U  R   R 
 C      O   O  N N N  N N N  EEE   C        T       FFF   O   O U   U  RRRR  
 C      O   O  N  NN  N  NN  E     C        T       F     O   O U   U  R  R  
  CCCC   OOO   N   N  N   N  EEEEE  CCCC    T       F      OOO   UUU   R   R 
```

Welcome to **Connect Four**, a classic two-player game now brought to life in a
Ruby-based command-line interface (CLI). Test your strategic thinking as you try
to outsmart your opponent and connect four discs in a row, either horizontally,
vertically, or diagonally!

## Game Rules

1. **Two Players**: This game is designed for two players. Player 1 uses the
   symbol 'X', and Player 2 uses the symbol 'O'.
2. **Objective**: Be the first to connect four of your discs in a straight
   line (horizontal, vertical, or diagonal).
3. **Gameplay**:
    - Players take turns dropping a disc into one of the seven columns.
    - A disc falls to the lowest available row in the selected column.
    - The game ends when one player connects four discs in a row or when the
      grid is full, resulting in a draw.

## Features

- **Interactive Gameplay**: Players can select the column by entering the column
  number.
- **Automated Board Display**: The game board updates after each move to reflect
  the current state.
- **Win Detection**: The game checks for a winner after each turn and announces
  when one player has connected four discs.
- **Draw Condition**: The game recognizes when the grid is full, and no more
  moves can be made, declaring a draw.

## Installation

To run the Connect Four game on your local machine, follow these steps:

### Prerequisites

Make sure you have Ruby installed. You can check this by running:

```bash
ruby -v
```

If Ruby is not installed, you can install it
using [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/).

You are to use `asdf` as well if you prefer. The goal is to get Ruby installed
on your machine.

### Clone the Repository

```bash
git clone https://github.com/nanafox/connect-four.git
cd connect-four
```

### Install Dependencies

Install the required gems by running:

```bash
bundle install
```

### Run the Game

After cloning the repository, you can start the game by running the following
command:

```bash
bundle exec rake play
```

## Game Flow

- The game starts by displaying an empty 6x7 grid.
- Players take turns selecting a column to drop their discs ('X' for Player 1, '
  O' for Player 2).
- The grid updates after each move to show the current game state.
- The game will declare the winner if a player connects four discs in any
  direction.
- If the grid is full without a winner, the game will declare a draw.

## Board Representation

The game board consists of seven columns and six rows, displayed as follows:

```text
  1   2   3   4   5   6   7
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
```

## Future Enhancements

- **AI Player**: Add a single-player mode with an AI opponent.
- **Difficulty Levels**: Implement different difficulty levels for AI opponents.
- **Web Interface**: Extend the game to a web-based platform using Ruby on
  Rails.

## Contributing

If you'd like to contribute to the project, feel free to fork the repository and
submit a pull request. All contributions are welcome!

## Acknowledgments

- Inspired by the classic **Connect Four** game.
- Built with ❤️ using Ruby.
