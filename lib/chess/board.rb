require 'chess/pieces'
require 'chess/start'

module Chess
  class Board
    attr_accessor :pieces

    def initialize
      @pieces = Chess::START_POS
    end

    def piece_at(square)
      @pieces.select{|piece| piece.square == square}.first
    end

    def find_pieces(piece_class, color)
      @pieces.select{|piece| (piece.class == piece_class) && (piece.color == color)}
    end

    def piece_at?(square)
      !(piece_at(square).nil?)
    end

    def attackers(color, square)
      aattackers = @pieces.select{ |piece| ((!(piece.is_a? Chess::Pawn) && (piece.move? square)) || (pawn_capture? piece, square)) && (piece.color != color) }
      aattackers.select { |piece| !blocked? piece, square }
    end

    def attacked?(color, square)
      !(attackers(color, square).empty?)
    end

    def valid_move?(piece, square)
      (piece.move? square) || (pawn_capture? piece, square)
    end

    def would_check?(piece, square)
      board = Chess::Board.new
      board.pieces = @board.pieces
      board.piece_at(piece.square).move square
      board.check? piece.color
    end

    def check?(color)
      king = find_pieces(Chess::King, color).first
      attacked? color, king.square
    end

    def castle?(square)
      if square == 'g1'
        rook = piece_at('h1')
        ['e1', 'e2', 'e3']
      elsif square == 'c1'
        rook = piece_at('a1')
      elsif square == 'g8'
        rook = piece_at('h8')
      elsif square == 'c8'
        rook = piece_at('a8')
      else
        false
      end
    end

    def blocked?(piece, square)
      (occupied? piece.color, square) || (!(piece.is_a? Chess::Knight) && (pieces_between? piece, square))
    end

    def occupied?(color, square)
      puts piece_at('e2')
      piece_at?(square) && (piece_at(square).color == color)
    end

    def pieces_between?(piece, square)
      squares = piece.squares_between(square)
      pieces = @pieces.select { |piece| squares.include? piece.square }
      !pieces.empty?
    end

    def pawn_capture?(piece, square)
      begin
      (piece.is_a? Chess::Pawn) && (piece.capture_move? square) && (!(piece_at(square).nil?) || ((piece.color == 'white') && (piece_at("#{square[0]}5").enpassant)) || ((piece.color == 'black') && (piece_at("#{square[0]}4").enpassant)))
      rescue
        return false
      end
    end

  end
end