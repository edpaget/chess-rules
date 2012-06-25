require 'chess/pieces'
require 'chess/start'

module Chess
  class Board
    class IllegalMove < StandardError
    end

    attr_accessor :pieces

    def initialize(pieces=[])
      @pieces = Array.new(Chess.starting_position)
    end

    def to_a
      @pieces.map { |piece| piece.to_ary }
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

    def move(start, eend)
      piece = piece_at(start)
      if legal_move? piece, eend
        piece.move eend
        enpassant_pawn.enpassant = false unless enpassant_pawn.nil?
      else
        raise IllegalMove, "Move from #{start} to #{eend} with #{piece_at(start)} is illegal."
      end
    end

    def legal_move?(piece, eend)
      (valid_move? piece, eend) && !(would_check? piece, eend) && !(blocked? piece, eend)
    end

    def attackers(color, square)
      aattackers = @pieces.select{ |piece| ((!(piece.is_a? Chess::Pawn) && (piece.move? square)) || (pawn_capture? piece, square)) && (piece.color != color) }
      aattackers.select { |piece| !blocked? piece, square }
    end

    def attacked?(color, square)
      !(attackers(color, square).empty?)
    end

    def capture?(start, eend)
      piece = piece_at(start)
      if piece.color == 'white'
        occupied? 'black', eend
      elsif piece.color == 'black'
        occupied? 'white', eend
      end
    end

    def legal_moves?(piece)
      ('a'..'h').each do |file|
        ('1'..'8').each do |rank|
          square = file + rank
          if legal_move? piece, square
            return true
          end
        end
      end
      return false
    end

    def enpassant_pawn
      @pieces.select { |piece| (piece.class == Chess::Pawn) && (piece.enpassant == true) }.first
    end

    def checkmate?(color)
      moveable_pieces = @pieces.select { |piece| (piece.color == color) && (legal_moves? piece) }
      (check? color) && (moveable_pieces.empty?)
    end

    def stalemate?(color)
      moveable_pieces = @pieces.select { |piece| (piece.color == color) && (legal_moves? piece) }
      !(check? color) && (moveable_pieces.empty?)
    end

    def valid_move?(piece, square)
      (piece.move? square) || (pawn_capture? piece, square) || (castle? piece, square)
    end

    def would_check?(piece, square)
      board = Chess::Board.new
      board.pieces = copy_pieces
      board.piece_at(piece.square).move square
      board.check? piece.color
    end

    def copy_pieces
      pieces = @pieces.map do |piece|
        piece_a = piece.to_ary
        piece.class.new(*piece_a)
      end
      return pieces
    end

    def check?(color)
      king = find_pieces(Chess::King, color).first
      attacked? color, king.square
    end

    def castle?(king, square)
      if king.is_a? Chess::King
        if square == 'g1'
          rook = piece_at('h1')
          check_a = ['f1', 'g1'].map { |square| attacked? 'white', square }
        elsif square == 'c1'
          rook = piece_at('a1')
          check_a = ['d1', 'c1', 'b1'].map { |square| attacked? 'white', square }
        elsif square == 'g8'
          rook = piece_at('h8')
          check_a = ['f8', 'g8'].map { |square| attacked? 'black', square }
        elsif square == 'c8'
          rook = piece_at('a8')
          check_a = ['d8', 'c8', 'b8'].map { |square| attacked? 'black', square }
        else
          return false
        end
      else
        return false
      end
      !(rook.nil?) && castle_flags?(king, rook) && !(check_a.include? true) && !(blocked? king, square)
    end

    def castle_flags?(king, rook)
      king.castle && rook.castle
    end

    def blocked?(piece, square)
      (occupied? piece.color, square) || (pieces_between? piece, square)
    end

    def occupied?(color, square)
      piece_at?(square) && (piece_at(square).color == color)
    end

    def pieces_between?(piece, square)
      if piece.is_a? Chess::Knight
        return false
      end
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