require 'chess-rules/piece'

module Chess
  class Board
    attr_accessor :pieces

    def self.setup_board
      return({ 'a1' => Rook.new('a1', 'white'),
               'b1' => Knight.new('b1', 'white'),
               'c1' => Bishop.new('c1', 'white'),
               'd1' => Queen.new('d1', 'white'),
               'e1' => King.new('e1', 'white'),
               'f1' => Bishop.new('f1', 'white'),
               'g1' => Knight.new('g1', 'white'),
               'h1' => Rook.new('h1', 'white'),
               'a2' => Pawn.new('a2', 'white'),
               'b2' => Pawn.new('b2', 'white'),
               'c2' => Pawn.new('c2', 'white'),
               'd2' => Pawn.new('d2', 'white'),
               'e2' => Pawn.new('e2', 'white'),
               'f2' => Pawn.new('f2', 'white'),
               'g2' => Pawn.new('g2', 'white'),
               'h2' => Pawn.new('h2', 'white'),
               'a7' => Pawn.new('a7', 'black'),
               'b7' => Pawn.new('b7', 'black'),
               'c7' => Pawn.new('c7', 'black'),
               'd7' => Pawn.new('d7', 'black'),
               'e7' => Pawn.new('e7', 'black'),
               'f7' => Pawn.new('f7', 'black'),
               'g7' => Pawn.new('g7', 'black'),
               'h7' => Pawn.new('h7', 'black'),
               'a8' => Rook.new('a7', 'black'),
               'b8' => Knight.new('b8', 'black'),
               'c8' => Bishop.new('c8', 'black'),
               'd8' => Queen.new('d8', 'black'),
               'e8' => King.new('e8', 'black'),
               'f8' => Bishop.new('f8', 'black'),
               'g8' => Knight.new('g8', 'black'),
               'h8' => Rook.new('h8', 'black') })
    end

    def initialize(hash={})
      @moves = 0
      @half_move_count = 0
      if hash.empty? 
        @pieces = self.class.setup_board
      elsif hash.key? :game
        if hash[:game].nil?
          raise "Empty Game"
        end
        @pieces = self.class.setup_board
        @game = hash[:game]
        @game.each { |move| make_move move }
      elsif hash.key? :position
        @pieces = hash[:position]
      elsif hash.key? :fen
        @pieces = Hash.new
        from_fen_position hash[:fen]
      else
        raise "Bad Argument Error"
      end
    end

    def move(half_move)
      if @to_move == 'white'
        @game.push [half_move, nil]
        @to_move = 'black'
      else
        @game.last.last = half_move
        @to_move = 'white'
        @move += 1
      end
      make_half_move half_move
    end

    def make_move(move)
      make_half_move move[0]
      if !(move[1].nil?)
        make_half_move move[1]
        @moves += 1
        @to_move = 'white'
      else
        @to_move = 'black'
      end
    end

    def make_half_move(move)
      piece = @pieces[move[0,2]]
      end_square = move[2,3]
      if (((piece.move? end_square) || (pawn_capture? piece, end_square)) && (legal_move? piece, end_square))
        reset_en_passant
        piece.move end_square
        @pieces.delete move[0,2]
        @pieces.merge! Hash[ end_square, piece ]
        if piece == Pawn
          @half_move_count = 0
        else
          @half_move_count += 1
        end
      else
        raise "Illegal Move"
      end
    end

    # May optionally pass an argument for move number as :move => move_number
    def piece_at(square, opts={})
      if opts.empty?
        board = @pieces
      elsif
        move_number = opts[:move]
        board_object = Board.new :game => (@game.first move_number)
        board = board_object.pieces
      end
      return board[square]
    end

    def pawn_capture?(pawn, move)
      if pawn == Pawn
        if capture? move
          true
        elsif en_passant? move
          true
        end
      else
        false
      end
    end

    def en_passant?(move)
      pawn = @pieces.select { |k, v| (v == Pawn) && (v.en_passant_square == move) }
      if pawn.empty?
        false
      else
        true
      end
    end

    def castle?(piece, square)
      if (piece == King) && !(check? piece.color) && (piece.castle)
        if piece.color == 'white'
          if square == 'g1'
            rook = @pieces['h1']
            if (rook == Rook) && (rook.castle) && !(attack? 'white', 'f1') && !(attack? 'white', 'g1')
              true
            else
              false
            end
          elsif square == 'c1'
            rook = @pieces['a1']
            if (rook == Rook) && (rook.castle) && !(attack? 'white', 'd1') && !(attack? 'white', 'c1')
              true
            else
              false
            end
          end
        elsif piece.color == 'black'
          if square == 'g8'
            rook = @pieces['h8']
            if (rook == Rook) && (rook.castle) && !(attack? 'black', 'f8') && !(attack? 'black', 'g8')
              true
            else
              false
            end
          elsif square =='c8'
            rook = @pieces['a8']
            if (rook == Rook) && (rook.castle) && !(attack? 'black', 'd8') && !(attack? 'black', 'c8')
              true
            else
              false
            end
          end
        end
      end
    end


    def reset_en_passant
      pawn = @pieces.select { |k, piece| ((piece == Pawn) && !(piece.en_passant_square.nil?)) }
      pawn.values.first.en_passant_square = nil unless pawn.empty?
      @pieces.merge! pawn
    end

    def legal_move?(piece, move)
      color = piece.color
      if ((blocked? piece, move) && (check? color))
        false
      else
        true
      end
    end

    def check?(color)
      king_square = find_king(color).square
      if attack? color, king_square 
        true
      else
        false
      end
    end

    def attack?(defending_color, square)
      attackers = @pieces.select { |key, piece| ((piece.color != defending_color) && (piece.move? square)) }
      attackers = attackers.select { |key, piece| !(blocked? piece, square) }
      if attackers.empty?
        false
      else
        true
      end
    end

    def find_king(color)
      king = @pieces.select { |key, piece| (piece.to_s == "King") && (piece.color == color) }
      king.values.first
    end

    def checkmate?(color)
      if check? color
        king = find_king color
        ('a'..'h').each do |alpha|
          ('1'..'8').each do |num|
            if ((king.move? (alpha + num)) && (legal_move? king, (alpha + num)))
              false
            end
          end
        end
        true
      else
        false
      end
    end

    def blocked?(piece, move)
      if (@pieces[move])
        if (piece.color == @pieces[move].color)
          true
        elsif ((piece == Pawn) && (piece.square[0] == move[0]))
          true
        elsif (piece == Knight)
          false 
        end
      elsif (piece == Knight)
        false 
      else
        squares = squares_between piece.square, move
        pieces_between = @pieces.select { |k, v| squares.include? k }
        if pieces_between.empty?
          false
        else
          true
        end
      end
    end

    def squares_between(start_square, end_square)
      squares = Array.new
      if (start_square[0] == end_square[0])
        count = start_square[1] < end_square[1] ? start_square[1].to_i : end_square[1].to_i
        finish = start_square[1] > end_square[1] ? start_square[1].to_i : end_square[1].to_i
        count += 1
        while count < finish
          squares.push "#{start_square[0]}#{count}"
          count += 1
        end
      elsif (start_square[1] == end_square[1])
        count = start_square[0] < end_square[0] ? start_square[0].ord : end_square[0].ord
        finish = start_square[0] > end_square[0] ? start_square[0].ord : end_square[0].ord
        count += 1
        while count < finish
          squares.push "#{count.chr}#{start_square[1]}"
          count += 1
        end
      else
        count_alpha = start_square[0] < end_square[0] ? start_square[0].ord : end_square[0].ord
        finish_alpha = start_square[0] > end_square[0] ? start_square[0].ord : end_square[0].ord
        count = count_alpha.chr == start_square[0] ? start_square[1].to_i : end_square[1].to_i
        finish = count_alpha.chr != start_square[0] ? start_square[1].to_i : end_square[1].to_i
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

    def from_fen_position(position)
      args = position.split ' '
      from_fen_pieces args[0]
      from_fen_to_move args[1]
      from_fen_castle args[2]
      from_en_passant args[3]
      from_half_move_count args[4]
      from_move_count args[5]
    end

    def from_fen_to_move(to_move)
      if to_move == 'w'
        @to_move = 'white'
      elsif to_move == 'b'
        @to_move = 'black'
      else
        raise "Wrong Color To Move"
      end
    end

    def from_fen_castle(castle)
      castle.each_char do |char|
        case char
        when 'K'
          @pieces['e1'].castle = true
          @pieces['h1'].castle = true
        when 'Q'
          @pieces['e1'].castle = true
          @pieces['a1'].castle = true
        when 'k'
          @pieces['e8'].castle = true
          @pieces['h8'].castle = true
        when 'q'
          @pieces['e8'].castle = true
          @pieces['a8'].castle = true
        end
      end
    end

    def from_en_passant(en_passant_square)
      if en_passant_square == '-'
        return
      else
        if @to_move == 'white'
          pawn_square = en_passant_square[0] + '4'
        else
          pawn_square = en_passant_square[0] + '7'
        end
        @pieces[pawn_square].en_passant_square = en_passant_square
      end
    end

    def from_half_move_count(count)
      @half_move_count = count.to_i
    end

    def from_move_count(count)
      @moves = count.to_i
    end

    def from_fen_pieces(pieces)
      fen_rows = pieces.split '/'
      fen_rows.reverse!
      (1..8).each do |row|
        fen_row = fen_rows[row - 1]
        count = 0
        column_offset = 0
        fen_row.each_char do |piece_notation|
          column = 97 + count + column_offset # 97 is the offset required to make the column letter a when count is zero
          square = column.chr + row.to_s
          case piece_notation
          when 'p'
            piece = Pawn.new(square, 'black')
          when 'P'
            piece = Pawn.new(square, 'white')
          when 'k'
            piece = King.new(square, 'black')
            piece.castle = false
          when 'K'
            piece = King.new(square, 'white')
            piece.castle = false
          when 'n'
            piece = Knight.new(square, 'black')
          when 'N'
            piece = Knight.new(square, 'white')
          when 'b'
            piece = Bishop.new(square, 'black')
          when 'B'
            piece = Bishop.new(square, 'white')
          when 'r'
            piece = Rook.new(square, 'black')
            piece.castle = false
          when 'R'
            piece = Rook.new(square, 'white')
            piece.castle = false
          when 'q'
            piece = Queen.new(square, 'black')
          when 'Q'
            piece = Queen.new(square, 'white')
          else 
            column_offset += (fen_row[count].to_i - 1)
          end
          @pieces.merge! Hash[square, piece] unless piece.nil?
          count += 1
        end
      end
    end

    # Opts may be a hash specifying a half-move of a particular color
    def fen_position(opts={})
      if opts.key? :move
        board = Board.new( :game => (@game.first opts[:move]))
        return board.fen_position
      end

      fen_string = fen_pieces + fen_color_to_move + fen_castle + fen_en_passant + fen_move_clocks

      return fen_string
    end

    def fen_move_clocks
      return @half_move_count.to_s + " " + @moves.to_s
    end

    def fen_en_passant
      pawn = @pieces.select { |k, v| (v == Pawn) && !(v.en_passant_square.nil?) }
      if pawn.empty?
        return '- '
      else
        square = pawn.values.first.en_passant_square
        return square + ' '
      end
    end

    def fen_color_to_move
      if @game.last.last.nil?
        return 'b '
      else
        return 'w '
      end
    end

    def fen_pieces
      fen_rows = Array.new
      ('1'..'8').each do |column|
        fen_string = String.new
        empty_squares = 0
        ('a'..'h').each do |row|
          square = row + column
          if @pieces.key? square
            piece = @pieces[square]
            fen_piece = piece.notation
            fen_piece ||= 'P'
            fen_piece.downcase! if piece.color == 'black'
            fen_string.concat empty_squares.to_s unless empty_squares == 0
            fen_string.concat fen_piece

            empty_squares = 0
          else
            empty_squares += 1
          end
        end
        fen_string.concat empty_squares.to_s unless empty_squares == 0
        fen_string.concat '/' unless column == '1'
        fen_rows.push fen_string
      end
      fen_string = fen_rows.reverse.join
      fen_string.concat " "
      return fen_string
    end


    def fen_castle
      fen_string = String.new 

      white_king = find_king 'white'
      black_king = find_king 'black'

      if (white_king.castle) && (@pieces['h1'] == Rook) && (@pieces['h1'].castle)
        fen_string.concat 'K'
      end
      if (white_king.castle) && (@pieces['a1'] == Rook) && (@pieces['a1'].castle)
        fen_string.concat 'Q'
      end
      if (black_king.castle) && (@pieces['h8'] == Rook) && (@pieces['h8'].castle)
        fen_string.concat 'k'
      end
      if (black_king.castle) && (@pieces['a8'] == Rook) && (@pieces['a8'].castle)
        fen_string.concat 'q'
      end
      fen_string.concat " "

      return fen_string
    end

    # Opts may be a hash specifying a half-move of a particular color
    def algebraic_notation(move, opts={})
      board = Board.new( :game => (@game.first move-1))
      white_move, black_move = @game[move-1]

      white_piece = board.pieces[white_move[0,2]]
      black_piece = board.pieces[black_move[0,2]] unless black_move.nil?

      white_notation = "#{white_piece.notation}#{"x" if board.capture? white_move[2,3]}"
      black_notation = " #{black_piece.notation}#{"x" if board.capture? black_move[2,3]}" unless black_move.nil?

      board.make_move @game[move-1]

      white_notation += "#{white_piece.square}#{("#" if board.checkmate? 'black') || ("+" if board.check? 'black')}"
      black_notation += "#{black_piece.square}#{("#" if board.checkmate? 'white') || ("+" if board.check? 'white')}" unless black_move.nil?
      return "#{move}. #{opts[:color] == 'black' ? "..." : white_notation} \t#{black_notation unless opts[:color] == 'white'}"
    end

    def capture?(move)
      if @pieces[move]
        true
      else
        false
      end
    end
  end
end
