require 'spec_helper'

describe Chess::Board do 
  it 'should be the default starting board if no arguments are passed' do
    board = Chess::Board.new
    board.pieces.should eq(Chess::START_POS)
  end

  it 'should retrieve the piece at a give square or return nil' do
    board = Chess::Board.new
    board.piece_at('e2').class.should be(Chess::Pawn)
    board.piece_at('e3').should be_nil
  end

end




