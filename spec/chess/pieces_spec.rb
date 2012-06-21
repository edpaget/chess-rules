require 'spec_helper'

describe Chess::Piece do
  before(:each) { @piece = Chess::Piece.new('e4', 'white') }
  it "should move when given a square to move to" do
    expect { @piece.move('e5') }.
      to change { @piece.square }.from('e4').to('e5')
  end

  it "should return an array of squares between two squares" do
    @piece.squares_between('e2').should eq(['e3'])
    @piece.squares_between('h1').should eq(['f3', 'g2'])
  end
end

describe Chess::Pawn do
  before(:each) do
    @w_pawn = Chess::Pawn.new('e2', 'white')
    @b_pawn = Chess::Pawn.new('e7', 'black')
    @moved_pawn = Chess::Pawn.new('e3', 'white')
  end

  it "should be able to move one or two squares from it's starting location" do
    @w_pawn.move?('e4').should be_true
    @b_pawn.move?('e5').should be_true
    @w_pawn.move?('e3').should be_true
    @b_pawn.move?('e4').should be_false
  end

  it 'should normally move one square at a time' do
    @moved_pawn.move?('e4').should be_true
    @moved_pawn.move?('e5').should be_false
  end

  it 'should set its en passant flag if it make a two square move' do 
    expect { @w_pawn.move ('e4') }.
      to change { @w_pawn.enpassant }.from(false).to(true)
  end

  it "should allow capture moves that are diagonally in front of it" do
    @w_pawn.capture_move?('d3').should be_true
    @b_pawn.capture_move?('d6').should be_true
  end
  
end

describe Chess::Knight do
  before(:each) do
    @knight = Chess::Knight.new('e4', 'white')
  end

  it "should move in an l-shape" do
    @knight.move?('g5').should be_true
    @knight.move?('f2').should be_true
    @knight.move?('e6').should be_false
  end
end

describe Chess::Bishop do
  before(:each) do
    @bishop = Chess::Bishop.new('e4', 'white')
  end

  it 'should move along diagonals' do
    @bishop.move?('a8').should be_true
    @bishop.move?('f5').should be_true
    @bishop.move?('d2').should be_false
  end
end

describe Chess::Rook do
  before(:each) do
    @rook = Chess::Rook.new('e4', 'white')
  end

  it "should move on the ranks and files" do
    @rook.move?('e8').should be_true
    @rook.move?('b4').should be_true
    @rook.move?('h8').should be_false
  end

  it "should have its castle flag set on creation unless false is passed an option" do
    @rook.castle.should be_true
    Chess::Rook.new('e4', 'white', false).castle.should be_false
  end

  it "should set it its castle flag to false after being moved" do
    expect { @rook.move('e5') }.
      to change{ @rook.castle }.from(true).to(false)
  end
end

describe Chess::Queen do
  before(:each) do
    @queen = Chess::Queen.new('e4', 'white')
  end

  it "should move like a rook or bishop" do
    @queen.move?('e8').should be_true
    @queen.move?('a8').should be_true
    @queen.move?('d2').should be_false
  end
end

describe Chess::King do
  before(:each) do 
    @king = Chess::King.new('e4', 'white')
  end

  it "should move one square in any direction" do
    @king.move?('e3').should be_true
    @king.move?('f5').should be_true
    @king.move?('d2').should be_false
  end

  it "should set the castle flag to false after moving for the first time" do
    expect { @king.move('e5') }.
      to change{ @king.castle }.from(true).to(false)
  end
end