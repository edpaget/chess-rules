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

  context 'making moves' do
    before(:each) do 
      @board = Chess::Board.new 
      @piece = @board.piece_at 'e2'
    end

    context 'only make moves if it is legal' do
      it "should not make a move if it results in mover\'s king being in check" do 
        @board.would_check?(@piece, 'e4').should be_false
        @board.pieces.push(Chess::Queen.new('e4', 'black'))
        @board.would_check?(@piece, 'd3').should be_true
      end

      it "should not make a move if it not possible for a piece to make it" do
        @board.valid_move?(@piece, 'e4').should be_true
        @board.valid_move?(@piece, 'e5').should be_false
      end

      it "should not make a move if the piece is blocked from making it" do
        @board.pieces.push(Chess::Pawn.new('e3', 'black'))
        @board.blocked?(@piece, 'e4').should be_false
      end

      it "should return an array of pieces attacking a given square" do
        @board.pieces.push(Chess::Pawn.new('e3', 'black'))
        @board.attackers('e3').should have(2).items
      end

      it "should return true if the attacks array has any pieces in it" do
        @board.pieces.push(Chess::Pawn.new('e3', 'black'))
        @board.attacked?('e3').should be_true
      end

      context "a piece is blocked from moving when" do
        it "has a piece of the same color occupying it's landing square" do
          @board.occupied?('white', 'e2').should be_true
        end

        it "has a piece along it's course of movement" do
          @board.pieces_between?(@piece, 'c2').should be_true
        end
      end
    end

    context 'when an illegal move is made' do
      it 'should raise an exception if there is an illegal move' do
        expect { @board.move 'e2', 'e4' }.
          to_not raise_error
        expect { @board.move 'e2', 'e5' }.
          to raise_error(Chess::Board::IllegalMove)
      end
    end

    context 'castles' do
      it 'should recognize a legal castle' do 
      end

      it 'should not allow a castle if the king is in check' do
      end

      it 'should not allow a castle if the king has moved' do
      end

      it 'should not allow a castle if the rook has moved' do
      end

      it 'should not allow a castle that would require the king to move through check' do
      end
    end

    context 'pawn moves' do
      it 'should allow pawns to move diagonally if they are making a capture' do
        @board.pieces.push(Chess::Pawn.new('d3', black))
        @board.pawn_capture(@piece, 'd3').should be true
      end

      it 'should allow pawns to capture other pawns via en passant' do
        pawn = Chess::Pawn.new('e5', 'white')
        @board.pieces.push(Chess::Pawn.new('f5', 'black', true))
        @board.pawn_capture?(pawn, 'f5')
      end

      it 'should clear any set en passant flags after the following half move' do
        @board.pieces.push(Chess::Pawn.new('f5', 'black', true))
        expect { @board.move('e2', 'e4') }.
          to change{@board.piece_at('f5').enpassant}.from(true).to(false)
      end
    end
      
    it 'should deferentiate between a move and a capture' do
    end


  end
end




