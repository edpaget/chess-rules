require 'spec_helper'

describe Chess::Piece do
  let(:piece) { Chess::Piece.new('e3', 'white') }
  describe "Piece class methods" do
    it "should keep a collection of all instances of Piece and its subclasses" do
      3.times do |n|
        Chess::Piece.new("e#{n+1}", 'white')
      end
      Chess::Piece.all.size.should eq(3)
    end

    it "should find an item from the collection by the piece's square" do
      Chess::Piece.find_by_square('e3').should eq(piece)
    end

    it "should move a piece if the move is legal and update the Hash and the instance" do
      piece.stub!(:move).and_return(true)
      piece.stub!(:square).and_return('e4')
      Chess::Piece.move 'e3e4'
      Chess::Piece.all.key?('e3').should be_false
      Chess::Piece.on_square('e4').square.should eq 'e4'
    end

    it "should find all pieces of the same color and class" do
      pieces = [ Chess::Piece.new('e3', 'black'), Chess::Piece.new('e4', 'black')]
      Chess::Piece.by_color_and_piece('black', Chess::Piece).should eq(pieces)
    end
  end

  describe "Piece instance methods" do
    it "should move a piece if it is a legal move" do
      piece.stub(:legal_move?).and_return(true)
      piece.move('e4').should be_true
    end

    it "should be equal to another piece of the same class and color" do
      test_piece = Chess::Piece.new('e1', 'white')
      piece.should eq(test_piece)
    end
  end

  describe "Methods to save to record using mongo_mapper" do
    let(:test_hash) {{ 'color' => 'white', 'square' => 'e3' }}
    it "saves the piece as a hash" do
      piece.to_hash.should eq(test_hash)
    end

    it "saves gives mongo a hash of a given item" do
      Chess::Piece.to_mongo(piece).should eq(test_hash)
    end

    it "creates a new object from mongo's record" do
      Chess::Piece.from_mongo(test_hash).should eq(piece)
    end
  end

end



