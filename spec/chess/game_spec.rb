require 'spec_helper'

describe Chess::Game do 
  
  it 'should always have a board' do
    game = Chess::Game.new
    game.board.class.should be(Chess::Board) 
  end

  it 'should create a new game from a list of moves' do
    expect { Chess::Game.new( :game => [['e2e4', 'e7e5']] ) }.
      to_not raise_error
  end

  it 'should create a new game from a board position and color to move' do
    piece = double('Piece')
    board = { 'e1' => piece, 'e2' => piece} 
    expect { Chess::Game.new({:to_move => 'white', :board => board}) }.
      to_not raise_error
  end

  it "should return a new game object n number of moves into a given game" do
    game = Chess::Game.new(:game => [['e2e4', 'c7c5'], ['g1f3', nil]])
    test_game = Chess::Game.new(:game => [['e2e4', 'c7c5']])
    game.at_move(1).should eq test_game
  end

  context 'test moves' do
    before(:each) do
      piece = double('Piece')
      piece.stub!(:color).and_return('white')

      board = double('Board')
      board.stub!(:move).and_return(true)
      board.stub!(:piece_at).and_return(piece)

      Chess::Board.stub!(:new).and_return(board)
      @game = Chess::Game.new()
    end

    it 'should keep track of the current color\'s move' do
      expect { @game.half_move('e2e4') }.
        to change {@game.to_move}.from('white').to('black')
    end

    it 'should not allow a move to be made for the wrong color' do
      expect { @game.half_move('e2e4') }.to_not raise_error
      expect { @game.half_move('d2d4') }.to raise_error(Chess::Game::WrongColor)
    end

    it 'should keep a record of the moves made' do
      @game.moves.class.should be(Array)
      expect { @game.half_move('e2e4') }.
        to change { @game.moves }.from([]).to([['e2e4', nil]])
    end

    it "should keep track of the number of moves since the last pawn move" do
      expect { @game.half_move('g1f3') }.
        to change { @game.halfmove_clock }.from(0).to(1)
    end
  end
end
