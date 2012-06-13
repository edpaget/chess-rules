require 'spec_helper'

describe Chess::Moves do
  class DummyClass
    def square
      'e4'
    end
  end

  before(:all) do
    @dummy = DummyClass.new
    @dummy.extends Chess::Moves
  end

  describe "ways pieces can move" do
    it "Rooks should move on ranks and files" do
      @dummy.rook_move?('e8').should be_true
      @dummy.rook_move?('a4').should be_true
      @dummy.rook_move?('a8').should be_false
    end

    it "Bishops should move on diagonals" do
      @dummy.bishop_move?('a8').should be_true
      @dummy.bishop_move?('b1').should be_true
      @dummy.bishop_move?('e8').should be_false
    end

    it "Knights should move in an L-shape" do
      @dummy.knight_move?('g5').should be_true
      @dummy.knight_move?('f6').should be_true
      @dummy.knight_move?('e8').should be_false
    end

    it "Queens should move like a bishop or rook" do
      @dummy.queen_move?('e8').should be_true
      @dummy.queen_move?('a8').should be_true
      @dummy.queen_move?('g5').should be_false
    end

    it "Pawns, should move one square towards the opposing side or two squares from it is starting rank" do
      @dummy.pawn_move?('e5').should be_true
      @dummy.stub!(square).and_return('e2')
      @dummy.pawn_move?('e4').should be_true
      @dummy.pawn_move?('e6').should be_false
      @dummy.pawn_move?('d3').should be_false
    end

    it "Pawns should be able to move diagonally when they are capturing a piece, including other pawns via en passant" do
      mummy_piece = mock('Piece')
      mummy_piece



end

shared_examples_for "a piece that can move" do
  let(:piece) { described_class.new('e3', 'white') }
  let(:piece) { (piece.class.to_s.downcase + "_move?").to_sym }

  it "should call the correct move method for the class type" do
    piece.should_expect(piece_move).and_return(true)
    piece.valid_move?('e4').should be_true
  end
end



