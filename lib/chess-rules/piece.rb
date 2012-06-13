require 'chess-rules/moves'

module Chess

  class Piece
    attr_accessor :color, :square

    def initialize(square, color)
      @color = color
      @square = square
    end

    def ==(piece)
      if (self.class == piece)
        true
      elsif (self.class == piece.class) && (self.color == piece.color)
        true
      else
        false
      end
    end

    def move(square)
      @square = square
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

    def move?(move)
      if (move[0] == @square[0]) || (move[1] == @square[1])
        true
      else
        false
      end
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

    def move?(move)
      if (move[0] == @square[0]) || (move[1] == @square[1])
        true
      elsif ((move[0].ord - @square[0].ord).abs == (move[1].to_i - @square[1].to_i).abs)
        true
      else
        false
      end
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

    def move?(move)
      if ((move[0].ord - @square[0].ord).abs > 1) || ((move[1].to_i - @square[1].to_i).abs > 1)
        false
      else
        true
      end
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

    def move?(move)
      if (((@color == 'white') && (move[1] == '1')) || ((@color == 'black') && move[1] == '8'))
        false
      elsif ((move[0] == @square[0]) && ((move[1].to_i - @square[1].to_i).abs == 1))
        true
      elsif (((@color == 'white') && (@square[1] == '2') && (move[1].to_i - @square[1].to_i == 2)) ||
             ((@color == 'black') && (@square[1] == '7') && (move[1].to_i - @square[1].to_i == -2)))
        true
      else
        false
      end
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

    def move?(move)
      if ((move[0].ord - @square[0].ord).abs == (move[1].to_i - @square[1].to_i).abs)
        true
      else
        false
      end
    end

  end

  class Knight < Piece
    def to_s
      "Knight"
    end

    def notation
      "N"
    end

    def move?(move)
      if (((move[0].ord - @square[0].ord).abs == 1) &&
          ((move[1].to_i - @square[1].to_i).abs == 2))
        true
      elsif (((move[0].ord - @square[0].ord).abs == 2) &&
             ((move[1].to_i - @square[1].to_i).abs == 1))
        true
      else
        false
      end
    end
  end
end