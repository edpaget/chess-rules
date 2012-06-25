require 'chess/board'

module Chess
  class Game
    attr_accessor :board, :moves, :to_move, :halfmove_clock

    class WrongColor < StandardError
    end

    def initialize(hash={})
      @to_move = 'white'
      @board = Chess::Board.new
      @moves = Array.new
      @halfmove_clock = 0
      if hash.key? :game
        hash[:game].each do |move|
          full_move move
        end
      elsif (hash.key? :board) && (hash.key? :to_move)
        @board = hash[:board]
        @to_move = hash[:to_move]
      elsif hash.empty?
      else
        raise "Illegal Arguments"
      end
    end

    def ==(game)
      self.moves == game.moves
    end

    def at_move(move_no)
      Chess::Game.new(:game => @moves.first(move_no))
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
      if piece == Chess::Pawn
        @halfmove_clock = 0
      else
        @halfmove_clock += 1
      end

      if @to_move == piece.color
        board.move start, eend
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