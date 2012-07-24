# Chess

A Ruby Gem to validate Chess moves and (eventually) produce algebraic and FEN notation

## Installation

Chess is not yet on Rubygems, due to the early state of its development and the prescene of a blank gem with a conflicting name

The best way to install Chess is using Bundler. Add the following to your Gemfile

    gem 'chess', :git => 'http://github.com/edpaget/chess-rules.git'
  
## Usage

Chess is mainly intended to validate chess moves, so it should be used by creating a new Chess game (either blank or with moves given to), and then feeding moves that need to be validating into the game. 

Create a new game as follows

    Chess::Game.new() # Blank Game
    Chess::Game.new( :game => [['e2e4', 'c7c5'], ['g1f3', nil]]) # Game with moves already made
  
The format for feeding moves into the game is group half-moves into an array of all the full-moves. If white made the last move, black's next half-move should be marked as nil.

You can then make moves by calling the `#move` method on a game

    game = Chess::Game.new()
    game.move 'e2e4'
  
If a move is not legal one of three errors will be raised 

    Chess::IllegalMove # if a move cannot be made by a piece or if it will put the mover's king in check
    Chess::WrongColor # if a move will move a piece by the color that made the previous move
    Chess::NoPieceOnSquare # if there isn't a piece on the square to be moved from 
  
## Dependencies

Chess only depends on rspec for running its test suite. 

Chess is not currently compatible with Ruby 1.8.7, but has been tested on both 1.9.2 and 1.9.3

## Future Directions

The main move forward with Chess will be to include support for output to various notation formats including algebriac notation and FEN notation. 

I also plan to add support for detecting more endgame conditions such as the fifty move rule, perpetual check, and 3-move repetition draws. 