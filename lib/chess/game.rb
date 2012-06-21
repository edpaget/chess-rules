require 'chess/board'

module Chess
  class Game
    attr_accessor :board, :moves, :to_move

    class WrongColor < StandardError
    end

    def initialize(hash={})
      @to_move = 'white'
      @board = Chess::Board.new
      @moves = Array.new
      if hash.empty?
      elsif hash.key? :game
        hash[:game].each do |move|
          full_move move
        end
      elsif (hash.key? :board) && (hash.key? :to_move)
        @board = hash(:board)
        @to_move = hash(:to_move)
      else
        raise "Illegal Arguments"
      end
    end

    def full_move(moves)
      white_move, black_move = moves

      half_move white_move unless white_move.nil?
      half_move black_move unless black_move.nil?
    end

    def half_move(move)
      start = move[0..1]
      eend =  move[2..3]
      
      piece = board.piece_at(start)

      if @to_move == piece.color
        board.move piece, eend
      else
        raise WrongColor
      end

      if @to_move == 'black'
        @moves.last[1] = move
        @to_move = 'white'
      elsif @to_move == 'white'
        @moves.push [move, nil]
        @to_move = 'black'
      end
    end

  end
end