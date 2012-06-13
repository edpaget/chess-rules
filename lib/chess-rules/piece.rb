require 'chess-rules/moves'

module Chess

  class Piece
    attr_accessor :color, :square

    @@pieces = Hash.new

    def initialize(square, color)
      @color = color
      @square = square
      @@pieces.store @square, self
    end

    def self.move(move)
      start_square = move[0..1]
      end_square = move[2..3]

      piece = @@pieces[start_square]
      piece.move end_square

      @@pieces.store end_square, piece
      @@pieces.delete start_square
    end

    def self.on_square(square)
      @@pieces[square]
    end

    def self.by_color_and_piece(color, piece)
      pieces = @@pieces.values
      compare_piece = piece.new("Illegal Square", color)
      pieces.select { |piece| piece == compare_piece }
    end

    def self.all
      @@pieces
    end

    def self.to_mongo(value)
      value.to_hash
    end

    def self.from_mongo(value)
      value.is_a?(self) ? value : self.new(value['square'], value['color'])
    end

    def ==(piece)
      (self.class == piece.class) && (self.color == piece.color)
    end

    def move(square)
      @square = square if legal_move? square
    end

    def to_hash
      return( { 'color' => @color, 'square' => @square } )
    end
  end

  class Rook < Piece
    attr_accessor :castle

    def initialize(square, color)
      @castle = true
      super square, color
    end

    def to_s
      "Rook"
    end

    def notation
      "R"
    end

    def move(move)
      @caste = false
      super move
    end
  end

  class Queen < Piece
    def to_s
      "Queen"
    end

    def notation
      "Q"
    end
  end

  class King < Piece
    attr_accessor :castle

    def initialize(square, color)
      @castle = true
      super square, color 
    end

    def to_s
      "King"
    end

    def notation
      "K"
    end

    def move(square)
      castle = false
      super square
    end

  end

  class Pawn < Piece
    attr_accessor :en_passant_square

    def to_s
      "Pawn"
    end

    def notation
      nil
    end


    def move(square)
      if (@square[1] == '2') && (square[1] == '4')
        @en_passant_square = square[0] + '3' 
      elsif (@square[1] == '7') && (square[1] == '5')
        @en_passant_square = square[0] + '6'
      end
      super square
    end
  end

  class Bishop < Piece
    def to_s
      "Bishop"
    end

    def notation
      "B"
    end
  end

  class Knight < Piece
    def to_s
      "Knight"
    end

    def notation
      "N"
    end
  end
end