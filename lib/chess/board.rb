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

    def attackers(square)
      aattackers = @pieces.select{ |piece| (piece.move? square) || (pawn_capture? piece, square) }
      aattackers.select { |piece| !blocked? piece, square }
    end

    def attacked?(square)
      !(attackers(square).empty?)
    end

    def blocked?(piece, square)
      !(occupied? piece.color, square) && ((piece.is_a? Chess::Knight) || !(pieces_between? piece, square))
    end

    def occupied?(color, square)
      !(piece_at(square).nil?) && (piece_at(square).color == color)
    end

    def pieces_between?(piece, square)
      squares = piece.squares_between(square)
      pieces = @pieces.select { |piece| squares.include? piece.square }
      !pieces.empty?
    end

  end
end