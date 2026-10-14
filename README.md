# Chess
[![CI](https://github.com/edpaget/chess-rules/actions/workflows/ci.yml/badge.svg)](https://github.com/edpaget/chess-rules/actions/workflows/ci.yml)

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

Chess has no runtime dependencies. Development uses rspec and rubocop.

Chess requires Ruby 3.3 or newer.

## Development

The toolchain and dev tasks are managed with [mise](https://mise.jdx.dev):

    mise install                       # installs the pinned Ruby, hk and pkl
    mise exec -- hk install --mise     # one-time per clone: installs the git hooks
    mise run ci                        # bundle install, then lint (rubocop) and test (rspec)

`mise run lint` and `mise run test` run the steps individually.

CI runs `mise run lint` on the pinned Ruby and `mise run test` on Ruby 3.3,
3.4 and 4.0; the spec job is non-blocking until `fix-ecs-component-delegate` lands.

Git hooks (configured in `hk.pkl`):

- **pre-commit** runs rubocop on staged Ruby files with safe autocorrect;
  corrected files are re-staged, and offenses that cannot be autocorrected
  block the commit.
- **pre-push** runs the full spec suite (`mise run test`).

Run them by hand with `mise exec -- hk check --all` or `mise exec -- hk fix --all`.

Note: the spec suite (and therefore the pre-push hook and `mise run ci`) is
red until task `fix-ecs-component-delegate` lands. Until then, push with
`git push --no-verify` to skip the pre-push hook.

## Future Directions

The main move forward with Chess will be to include support for output to various notation formats including algebriac notation and FEN notation. 

I also plan to add support for detecting more endgame conditions such as the fifty move rule, perpetual check, and 3-move repetition draws. 