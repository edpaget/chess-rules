module Chess
  class Piece
    attr_accessor :square, :color

    def initialize(square, color)
      @square = square
      @color = color
    end

    def move(square)
      @square = square
    end

    def rank_and_file(square)
      [square[0].ord, square[1].to_i]
    end

    def squares_between(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      squares = Array.new

      if s_file == e_file
        count, finish = s_rank < e_rank ? [s_rank, e_rank] : [e_rank, s_rank]
        count += 1
        while count < finish
          squares.push "#{s_file.chr}#{count}"
          count += 1
        end
      elsif s_rank == e_rank
        count, finish = s_file < e_file ? [s_file, e_file] : [e_file, s_file]
        count += 1
        while count < finish
          squares.push "#{count.chr}#{s_rank}"
          count += 1
        end
      else
        count_alpha, finish_alpha, count, finish = s_file < e_file ? [s_file, e_file, s_rank, e_rank] : [e_file, s_file, e_rank, s_rank]
        count_alpha += 1
        if count > finish
          count -= 1
        else
          count += 1
        end
        while count_alpha < finish_alpha
          squares.push "#{count_alpha.chr}#{count}"
          count_alpha += 1
          if count > finish
            count -= 1
          else
            count += 1
          end
        end
      end

      return squares
    end

    def to_ary
      [@square, @color]
    end

  end

  class King < Piece
    attr_reader :castle

    def initialize(square, color, castle=true)
      @castle = castle
      super square, color
    end

    def to_s
      "King"
    end

    def notation
      "K"
    end

    def move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      ((s_file - e_file).abs) <= 1 && ((s_rank - e_rank).abs <= 1)
    end

    def move(square)
      if @castle
        @castle = false
      end
      super square
    end

    def to_ary
      [@square, @color, @castle]
    end
  end

  class Queen < Piece
    def to_s
      "Queen"
    end

    def notation
      "Q"
    end

    def move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      (s_file == e_file) || (s_rank == e_rank) || ((s_file - e_file).abs) == ((s_rank - e_rank).abs)
    end
  end

  class Rook < Piece
    attr_reader :castle

    def initialize(square, color, castle=true)
      @castle = castle
      super square, color
    end

    def to_s
      'Rook'
    end

    def notation
      'R'
    end

    def move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      (s_file == e_file) || (s_rank == e_rank)
    end

    def move(square)
      if @castle
        @castle = false
      end
      super square
    end

    def to_ary
      [@square, @color, @castle]
    end

  end

  class Bishop < Piece
    def to_s
      "Bishop"
    end

    def notation
      "B"
    end

    def move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      ((s_file - e_file).abs) == ((s_rank - e_rank).abs)
    end
  end

  class Knight < Piece
    def to_s
      "Knight"
    end

    def notation
      "N"
    end

    def move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square
      (((s_file - e_file).abs == 2) && ((s_rank - e_rank).abs == 1)) || (((s_file - e_file).abs == 1) && ((s_rank - e_rank).abs == 2))
    end
  end

  class Pawn < Piece
    attr_accessor :enpassant

    def initialize(square, color, enpassant=false)
      @enpassant = enpassant
      super square, color
    end

    def to_s
      "Pawn"
    end

    def notation
      ""
    end

    def move(square)
      if double_move? square
        @enpassant = true
      end
      super square
    end

    def move?(square)
      (single_move? square) || (double_move? square)
    end

    def capture_move?(square)
      s_file, s_rank = rank_and_file @square
      e_file, e_rank = rank_and_file square

      ((s_file - e_file).abs == 1) && ((s_rank - e_rank).abs == 1)
    end

    def single_move?(square)
      s_file, s_rank = rank_and_file(@square)
      e_file, e_rank = rank_and_file(square)

      if @color == 'black'
        (s_file == e_file) && ((s_rank - 1) == e_rank)
      elsif @color == 'white'
        (s_file == e_file) && ((s_rank + 1) == e_rank)
      end
    end

    def double_move?(square)
      s_file, s_rank = rank_and_file(@square)
      e_file, e_rank = rank_and_file(square)
      
      if (@color == 'white') && (s_rank == 2)
        (s_file == e_file) && (e_rank == 4)
      elsif (@color == 'black') && (s_rank == 7)
        (s_file == e_file) && (e_rank == 5)
      end
    end

    def to_ary
      [@square, @color, @enpassant]
    end
  end
end