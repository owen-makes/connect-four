require_relative '../main.rb'

describe ConnectFour do
  subject(:game) {described_class.new}
  
  describe '#initialize' do
    it 'generates board as nested array' do
      board = game.board
      expect(board).to be_an_instance_of(Array)    
    end

    it 'generates board_ui' do
      board_ui = game.board_ui
      expect(board_ui).to be_an_instance_of(String)
    end
  end


  describe '#pretty_print' do
    it 'returns board ui' do
      board = game.board
      board_ui = "|0 |1 |2 |3 |4 |5 |6 |\n"\
      "|__|#{"__|"*6}\n"\
      "|#{board[0][0]}|#{board[1][0]}|#{board[2][0]}|#{board[3][0]}|#{board[4][0]}|#{board[5][0]}|#{board[6][0]}|\n"\
      "|#{board[0][1]}|#{board[1][1]}|#{board[2][1]}|#{board[3][1]}|#{board[4][1]}|#{board[5][1]}|#{board[6][1]}|\n"\
      "|#{board[0][2]}|#{board[1][2]}|#{board[2][2]}|#{board[3][2]}|#{board[4][2]}|#{board[5][2]}|#{board[6][2]}|\n"\
      "|#{board[0][3]}|#{board[1][3]}|#{board[2][3]}|#{board[3][3]}|#{board[4][3]}|#{board[5][3]}|#{board[6][3]}|\n"\
      "|#{board[0][4]}|#{board[1][4]}|#{board[2][4]}|#{board[3][4]}|#{board[4][4]}|#{board[5][4]}|#{board[6][4]}|\n"\
      "|#{board[0][5]}|#{board[1][5]}|#{board[2][5]}|#{board[3][5]}|#{board[4][5]}|#{board[5][5]}|#{board[6][5]}|\n"\
      "#{"⁻"*22}"
      expect(game.pretty_print).to eq(board_ui)
    end
  end

  describe '#play' do
    it 'exits loop and calls #announce_winner' do
      player1 = game.player1
      win_msg = "Game Over"
      game.make_move(player1, 0)
      game.make_move(player1, 0)
      game.make_move(player1, 0)
      game.make_move(player1, 0)
      expect(game).to receive(:announce_winner)
      game.play
    end
  end

  describe '#make_move' do
    it 'updates board' do
      player = game.player2
      column = 0
      expect{game.make_move(player, column)}.to change { game.board[0][5] }.from("⭕").to(player)
    end
  end

  describe '#game_over?' do
    it 'returns true when game won' do
      player = game.player2
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      expect(game.game_over?).to eq(true)
    end

    it 'returns false when game is ongoing' do
      player1 = game.player1
      player2 = game.player2
      game.make_move(player1, 0)
      game.make_move(player1, 0)
      game.make_move(player2, 0)
      game.make_move(player2, 0)
      expect(game.game_over?).to eq(false)
    end
  end

  describe "#win?" do
    it 'returns true when player 1 has won' do
      player = game.player1
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      expect(game.win?(player)).to eq(true)
    end

    it 'returns true when player 2 has won' do
      player = game.player2
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      game.make_move(player, 0)
      expect(game.win?(player)).to eq(true)
    end

    it 'returns false when no player won' do
      player1 = game.player1
      player2 = game.player2
      game.board[0].shift(4)
      game.board[0].push(player1, player2, player1, player2)
      expect(game.win?(player2)).to eq(false)
      expect(game.win?(player1)).to eq(false)
    end
  end

  describe "#board_full?" do
    it 'returns true when board is full' do
      player = game.player2
      game.board.map { |column| column.fill(player) }
      expect(game.board_full?).to eq(true)
    end

    it 'returns false when board not full' do
      expect(game.board_full?).to eq(false)
    end
  end

  describe '#turn' do
    context 'when user inputs one incorrect value, then a valid input' do
      before do
        invalid_input = "10\n"
        valid_input = "3\n"
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'breaks loop if input is valid' do
        player = game.player1
        msg = "Player(#{player}) select a column:"
        expect(game).to receive(:puts).with(msg).twice
        expect(game).to receive(:make_move).with(player,3)
        game.turn(player)
      end
     end

    it 'calls make_move' do
      player = game.player1
      allow(game).to receive(:gets).and_return("5\n")
      allow(game).to receive(:verify_input).and_return(true)
      expect(game).to receive(:make_move).with(player, 5)
      game.turn(player)
    end

  end

  describe '#verify_input' do
    context 'when user selects a column out of bounds' do
      user_input = 8
      it 'returns false' do
        expect(game.verify_input(user_input)).to eq(false)
      end
    end
    context 'when selected column is full' do
      game = described_class.new
      game.board[0].fill('🟡')
      user_input = 0

      it 'returns false' do
        expect(game.verify_input(user_input)).to eq(false)
      end
    end

    context 'when input a string' do
      user_input = 'F'
      it 'returns false' do
        expect(game.verify_input(user_input)).to eq(false)
      end
    end

    it 'returns true when input is valid' do
      user_input = 1
      expect(game.verify_input(user_input)).to eq(true)
    end
  end
end