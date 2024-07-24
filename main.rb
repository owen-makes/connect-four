class ConnectFour
  attr_reader :board, :board_ui, :player1, :player2
  
  TITLE_BANNER = "\n"\
  "  /$$$$$$                                                      /$$           /$$   /$$\n"\
  " /$$__  $$                                                    | $$          | $$  | $$\n"\
  "| $$  \\__/  /$$$$$$  /$$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$        | $$  | $$\n"\
  "| $$       /$$__  $$| $$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/        | $$$$$$$$\n"\
  "| $$      | $$  \\ $$| $$  \\ $$| $$  \\ $$| $$$$$$$$| $$        | $$          |_____  $$\n"\
  "| $$    $$| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$        | $$ /$$            | $$\n"\
  "|  $$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/            | $$\n"\
  " \\______/  \\______/ |__/  |__/|__/  |__/ \\_______/ \\_______/   \\___/              |__/\n"

  def initialize
    @board = Array.new(7) {Array.new(6,"⭕")}
    @board_ui = pretty_print
    @player1 = '🟡'
    @player2 = '🔵'
  end

  def pretty_print
    "|0 |1 |2 |3 |4 |5 |6 |\n"\
      "|__|#{"__|"*6}\n"\
      "|#{@board[0][0]}|#{@board[1][0]}|#{@board[2][0]}|#{@board[3][0]}|#{@board[4][0]}|#{@board[5][0]}|#{@board[6][0]}|\n"\
      "|#{@board[0][1]}|#{@board[1][1]}|#{@board[2][1]}|#{@board[3][1]}|#{@board[4][1]}|#{@board[5][1]}|#{@board[6][1]}|\n"\
      "|#{@board[0][2]}|#{@board[1][2]}|#{@board[2][2]}|#{@board[3][2]}|#{@board[4][2]}|#{@board[5][2]}|#{@board[6][2]}|\n"\
      "|#{@board[0][3]}|#{@board[1][3]}|#{@board[2][3]}|#{@board[3][3]}|#{@board[4][3]}|#{@board[5][3]}|#{@board[6][3]}|\n"\
      "|#{@board[0][4]}|#{@board[1][4]}|#{@board[2][4]}|#{@board[3][4]}|#{@board[4][4]}|#{@board[5][4]}|#{@board[6][4]}|\n"\
      "|#{@board[0][5]}|#{@board[1][5]}|#{@board[2][5]}|#{@board[3][5]}|#{@board[4][5]}|#{@board[5][5]}|#{@board[6][5]}|\n"\
      "#{"⁻"*22}"
  end

  def play
    puts TITLE_BANNER
    puts @board_ui
    until game_over?
      turn(@player1)
      turn(@player2)
    end
    announce_winner
  end

  def turn(player)
    puts "Player(#{player}) select a column:"
    input = gets.chomp.to_i
    until verify_input(input)
      puts "Player(#{player}) select a column:"
      input = gets.chomp.to_i
    end
    make_move(player, input)
    puts pretty_print
  end

  def make_move(player, column)
    a = @board[column]
    if a.all?("⭕")
      @board[column][-1] = player
    else
      @board[column][a.rindex("⭕")] = player
    end
    pretty_print
  end

  def verify_input(user_input)
    begin
      if user_input > 6 || @board[user_input].none?("⭕")
        false
      else
        true
      end
    rescue
      false
    end
  end

  def game_over?
    win?(@player1) || win?(@player2) || board_full?
  end

  def announce_winner
    if win?(@player1)
      puts "Player 1 (#{@player1}) wins!"
    elsif win?(@player2)
      puts "Player 2 (#{@player1}) wins!"
    else
      puts "It's a draw! The board is full"
    end
  end


  def win?(player)
    win_combinations.any? do |combination|
      combination.all? { |row, col| @board[col][row] == player }
    end
  end

  def board_full?
    @board.all? { |column| column.none? { |cell| cell == "⭕" } }
  end
  
  def win_combinations
    horizontal_wins + vertical_wins + diagonal_wins_up + diagonal_wins_down
  end
  
  def horizontal_wins
    (0..5).flat_map do |row|
      (0..3).map do |col|
        [[row, col], [row, col+1], [row, col+2], [row, col+3]]
      end
    end
  end
  
  def vertical_wins
    (0..6).flat_map do |col|
      (0..2).map do |row|
        [[row, col], [row+1, col], [row+2, col], [row+3, col]]
      end
    end
  end
  
  def diagonal_wins_up
    (0..2).flat_map do |row|
      (0..3).map do |col|
        [[row, col], [row+1, col+1], [row+2, col+2], [row+3, col+3]]
      end
    end
  end
  
  def diagonal_wins_down
    (3..5).flat_map do |row|
      (0..3).map do |col|
        [[row, col], [row-1, col+1], [row-2, col+2], [row-3, col+3]]
      end
    end
  end
end

play = ConnectFour.new
play.play