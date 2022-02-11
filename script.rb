class Game

  WINNING_COMBINATION = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 5], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 9]]

  def initialize(player_1, player_2)
    @board = Array.new(10)
    @current_player_id = 0
    @players = [player_1.new(self, 'X', 'Player 1'), player_2.new(self, 'O', 'Player 2')]
  end

  attr_reader :board, :current_player_id

  def play_game
    loop do 
      place_marker(current_player)

     if player_won?(current_player)
       puts "#{current_player} has won!"
       print_board
       return
     elsif board_full?
       puts "The game comes to a draw."
       print_board
       return
     end

     switch_player
    end
  end

  def place_marker(player)
    position = player.select_position
    puts "#{player} has put #{player.marker} on #{position}"
    @board[position] = player.marker
  end

  def free_position
    (1..9).select{ |position| @board[position].nil? }
  end

  def player_won?(player)
    WINNING_COMBINATION.any? do |combination|
      combination.all?{ |position| @board[position] == player.marker }
    end
  end

  def board_full?
    free_position.empty?
  end

  def switch_player
    @current_player_id = other_player_id
  end

  def current_player
    @players[current_player_id]
  end

  def other_player_id
    1 - @current_player_id
  end

  def opponent
    @players[other_player_id]
  end

  def print_board
    column_seperator, row_seperator = ' | ', '--+--+--'
    rows = [[1, 2, 3],[4, 5, 6], [7, 8, 9]]
    label_for_board = ->(position){ @board[position] ? @board[position] : position }
    row_position = ->(row){ row.map(&label_for_board).join(column_seperator) }
    display_row = rows.map(&row_position)
    puts display_row.join("\n" + row_seperator + "\n")
  end
end


class Player
  def initialize(game, marker, name)
    @game = game
    @marker = marker
    @name = name
  end

  attr_reader :marker


  def select_position
    @game.print_board
    loop do
      print "Select #{marker} position: "
      selection = gets.to_i
      return selection if @game.free_position.include?(selection)
      puts "The position is not available."
    end
  end

  def to_s
    @name
  end

end

class SecondPlayer < Player
  def select_position
    opponent_marker = @game.opponent.marker
    @game.print_board
    loop do
      print "Select #{marker} position: "
      selection = gets.to_i
      return selection if @game.free_position.include?(selection)
      puts "The position is not available."
    end
  end
end

play_game = Game.new(Player, SecondPlayer)
play_game.play_game