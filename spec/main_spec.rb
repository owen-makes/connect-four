require_relative '../main.rb'

describe ConnectFour do
  subject(:game) {described_class.new}
  
  describe '#initialize' do
    it 'prints board when initialized' do
      board = game.board
      expect(board).to_not be_nil    
    end
  end
end