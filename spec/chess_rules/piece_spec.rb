require 'spec_helper'

describe Chess::Piece do
  describe "Piece class methods" do
    it "should keep a collection of all instances of Piece and its subclasses" do
      3.times do
        Chess::Piece.new('white', 'e3')
      end
      Chess::Piece.instances.size.should eq(3)
    end

    it "should find an item from the collection by the piece's square" do
      piece = Chess::Piece.new('white', 'e3')
      Chess::Piece.find_by_square('e3').should eq(piece)
    end

    it "should store instances in a Hash with the piece's square as the key" do
      piece = Chess::Piece.new('white', 'e3')
      Chess::Piece['e3'].should eq(piece)
    end

    it "should move a piece if the move is legal and update the Hash and the instance" do
      piece = Chess::Piece.new('white', 'e3')
      piece.stub!(:move).and_return(true)
      piece.stub!(:square).and_return('e4')
      Chess::Piece.move 'e3e4'
      Chess::Piece.key?('e3').should be_false
      Chess::Piece['e4'].square.should_be 'e4'
    end
  end

  describe "Piece instance methods" do
    let(:piece) { Chess::Piece.new('white', 'e3') }
    it "should move a piece if it is a legal move" do
      piece.stub(:legal_move?).return(true)
      piece.move('e4').should be_true
    end

    it "should be equal to another piece of the same class and color" do
      test_piece = Chess::Piece.new('white', 'e1')
      piece.should eq(test_piece)
    end
  end
end



