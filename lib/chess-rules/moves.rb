module Chess
  module Moves
    def move?(move)
      if (move[0] == @square[0]) || (move[1] == @square[1])
        true
      else
        false
      end
    end
    def move?(move)
      if ((move[0].ord - @square[0].ord).abs > 1) || ((move[1].to_i - @square[1].to_i).abs > 1)
        false
      else
        true
      end
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
    def move?(move)
      if ((move[0].ord - @square[0].ord).abs == (move[1].to_i - @square[1].to_i).abs)
        true
      else
        false
      end
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
