# frozen_string_literal: true

require_relative "lib/game"

# write a nice welcome ascii art for the connect-four game

puts <<-ASCII

  CCCC   OOO   N   N  N   N  EEEEE  CCCC  TTTTT     FFFFF  OOO  U   U  RRRR#{'  '}
 C      O   O  NN  N  NN  N  E     C        T       F     O   O U   U  R   R#{' '}
 C      O   O  N N N  N N N  EEE   C        T       FFF   O   O U   U  RRRR#{'  '}
 C      O   O  N  NN  N  NN  E     C        T       F     O   O U   U  R  R#{'  '}
  CCCC   OOO   N   N  N   N  EEEEE  CCCC    T       F      OOO   UUU   R   R#{' '}

ASCII

puts "Welcome to Connect Four!"
puts "-------------------------"
puts "Instructions:"
puts "1. The game is played on a grid that's 7 columns by 6 rows."
puts "2. Two players take turns to drop a disc into a column."
puts "3. The first player to connect four discs in a row wins."
puts "4. The game ends when the board is full and no player has won."
puts "5. Good luck!"
puts "-------------------------"

begin
  game = Game.new
  game.play
rescue StandardError
  puts "Game exited unexpectedly. Please try again."
end
