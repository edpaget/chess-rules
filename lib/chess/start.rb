# frozen_string_literal: true

module Chess
  module Start
    STARTING_POSITION = [
      Chess::Rook.new("a1", "white"),
      Chess::Knight.new("b1", "white"),
      Chess::Bishop.new("c1", "white"),
      Chess::Queen.new("d1", "white"),
      Chess::King.new("e1", "white"),
      Chess::Bishop.new("f1", "white"),
      Chess::Knight.new("g1", "white"),
      Chess::Rook.new("h1", "white"),
      Chess::Pawn.new("a2", "white"),
      Chess::Pawn.new("b2", "white"),
      Chess::Pawn.new("c2", "white"),
      Chess::Pawn.new("d2", "white"),
      Chess::Pawn.new("e2", "white"),
      Chess::Pawn.new("f2", "white"),
      Chess::Pawn.new("g2", "white"),
      Chess::Pawn.new("h2", "white"),
      Chess::Pawn.new("a7", "black"),
      Chess::Pawn.new("b7", "black"),
      Chess::Pawn.new("c7", "black"),
      Chess::Pawn.new("d7", "black"),
      Chess::Pawn.new("e7", "black"),
      Chess::Pawn.new("f7", "black"),
      Chess::Pawn.new("g7", "black"),
      Chess::Pawn.new("h7", "black"),
      Chess::Rook.new("a8", "black"),
      Chess::Knight.new("b8", "black"),
      Chess::Bishop.new("c8", "black"),
      Chess::Queen.new("d8", "black"),
      Chess::King.new("e8", "black"),
      Chess::Bishop.new("f8", "black"),
      Chess::Knight.new("g8", "black"),
      Chess::Rook.new("h8", "black"),
    ]
  end
end
