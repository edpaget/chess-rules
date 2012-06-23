require 'spec_helper'

describe Chess::Board do 
  before(:each) do
    @board = Chess::Board.new
    @piece = @board.piece_at('e2')
  end

  it 'should retrieve the piece at a give square or return nil' do
    @board.piece_at('e2').class.should be(Chess::Pawn)
    @board.piece_at('e3').should be_nil
  end

  it "should retrieve pieces by their class and color" do
    @board.find_pieces(Chess::Rook, 'white').should have(2).items
  end

  it "should return true if there is a piece on the square" do
    @board.piece_at('e2').should be_true
    @board.piece_at('e3').should be_false
  end

  context "a piece is blocked from moving" do
    it "if a piece of the same color is on it\' destination square" do
      @board.occupied?('white', 'd2').should be_true
      @board.blocked?(@piece, 'd2').should be_true
    end

    it "if there are pieces between it and it's destination" do
      @board.pieces_between?(@piece, 'c2').should be_true
      @board.blocked?(@piece, 'c2').should be_true
    end

    it "is not blocked if the destintation square is open or captureable and there are no pieces in between" do
      @board.blocked?(@piece, 'e4').should be_false
    end
  end

  context "a piece is being attacked" do
    before(:each) do
      @board.pieces.push(Chess::Pawn.new('d3', 'black'))
    end

    it "should generate an array of attacking pieces" do
      @board.attackers('black', 'd3').should have(2).items
    end

    it "should return true if there are pieces attacking a square" do
      @board.attacked?('black', 'd3').should be_true
    end
  end

  it "should return true if a piece is can make a move to a square" do
    @board.valid_move?(@piece, 'e4').should be_true
    @board.valid_move?(@piece, 'e5').should be_false
  end

  describe "when a piece is threating check" do
    before(:each) do
      @board = Chess::Board.new
      @board.pieces.push(Chess::Queen.new('e4', 'black'))
      @piece = @board.piece_at('e2')
    end

    it "should return false if no pieces are in check" do
      @board.check?('white').should be_false
    end

    it "should return true if a move would result in check" do
      @board.would_check?(@piece, 'd3').should be_true
      @board.would_check?(@piece, 'e3').should be_false
    end

    it "should return true if the king of the given color is in check" do
      @piece.move 'd3'
      @board.check?('white').should be_true
    end
  end

  it "should allow a pawn to make a diagonal move to capture" do
    @board.pieces.push(Chess::Pawn.new('d3', 'black'))
    @board.pawn_capture?(@piece, 'd3')
  end

  it "should allow a pawn to make a diagonal move to enpassant another pawn" do
    @board.pieces.push(Chess::Pawn.new('d5', 'black', true))
    pawn = Chess::Pawn.new('e5', 'white')
    @board.pieces.push(pawn)
    @board.pawn_capture?(pawn, 'd6')
  end

  context "basic castling" do
    let(:king) { @board.piece_at('e1') }
    let(:rook) { @board.piece_at('h1') }
    it "should only castle if the King and Rook have castle flags set" do
      @board.castle_flags?(king, rook).should be_true
    end

    it "should be false if the King or Rook have castle falgs set to false" do
      king.stub!(:castle).and_return(false)
      @board.castle_flags?(king, rook).should be_false
      rook.stub!(:castle).and_return(false)
      @board.castle_flags?(king, rook).should be_false
    end
  end

  context "king side castle white" do
    let(:king) { @board.piece_at('e1') }

    it "should not castle if there are pieces blocking the attack" do
      @board.castle?(king, 'g1').should be_false
    end

    it "should castle if there are no pieces blocking the attack and the king is not in check" do
      @board.pieces.delete_if {|d_piece| (d_piece.square == 'f1') || (d_piece.square == 'g1') }
      @board.castle?(king, 'g1').should be_true
    end
  end

  context "making a move" do
    before(:each) { @board = Chess::Board.new }

    it "should not raise an error if a move is legal" do
      expect { @board.move('e2', 'e4') }.
        to_not raise_error
    end

    it "should raise an error if a move is illegal" do
      expect { @board.move('e2', 'e5') }.
        to raise_error(Chess::Board::IllegalMove)
    end

    it "should reset any pawns with the enpassant flag set to true afterwards" do
      pawn = Chess::Pawn.new('d5', 'black', true)
      @board.pieces.push(pawn)
      expect { @board.move('e2', 'e3') }.
        to change { @board.enpassant_pawn }.from(pawn).to(nil)
    end
  end

  it "should return true if a move would capture a piece" do
    @board.pieces.push(Chess::Pawn.new('d3', 'black'))
    @board.capture?('e2', 'd3').should be_true
  end

  it "should return true if there is checkmate" do
    @board.pieces.delete_if { |piece| piece.square == 'f2' }
    @board.pieces.push(Chess::Queen.new('f2', 'black'))
    @board.pieces.push(Chess::Queen.new('e3', 'black'))
    @board.checkmate?('white').should be_true
  end

  it "should return true if there is stalemate" do
    @board.pieces.delete_if { |piece| (piece.color == 'white') && (piece.class != Chess::King) }
    @board.pieces.push(Chess::Rook.new('h2', 'black'))
    @board.pieces.push(Chess::Rook.new('f3', 'black'))
    @board.pieces.push(Chess::Rook.new('d3', 'black'))
    @board.stalemate?('white').should be_true
  end

end
