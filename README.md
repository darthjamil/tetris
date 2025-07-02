# Tetris
This is Tetris implemented in Swift.

For details on how to play Tetris, terminology, and game mechanics, see 
[the Tetris Wiki](https://tetris.fandom.com/wiki/Tetris_Wiki).

# API & Usage
The codebase is broken up into the core game engine and a UI on top of it. 

The engine can be used to play Tetris programmatically, without a UI. To start
playing with the engine, first initialize the game:

    let game = Tetris(startLevel: 1)

By default, the game starts at level 1. However, this can be overridden via
the ctor argument, since many advanced players opt to start at level 18.

The game can also be initialized with custom mechanics. More on this later.

## Get Playfield Information
The following information can be interrogated about the game at any time.

To get the current state of the playfield, call

    game.playfield -> [[Tetromino?]]

Where `Tetromino` is defined as

    enum Tetromino {
        L, J, S, Z, T, I
    }

This will return a 2D array representing the grid of the playfield. Each cell in
the grid is a `Tetromino`, representing the piece that currently occupies the cell.
If no tetromino occupies a cell, it will be `nil`.

## Play the Game
To play the game, move the currently descending tetromino by calling the 
following APIs

    game.rotate() -> PlayResult
    game.left() -> PlayResult
    game.right() -> PlayResult
    
These methods move the currently descending tetromino left, right, or rotate 
it 90 degrees clockwise. The return value is not strictly needed. However, 
it's returned so that the UI can provide visual/audio feedback without 
having to diff the playfield.

To move the current tetromino down one space, or to drop it, call the following
APIs:

    game.down() -> PlayResult
    game.drop() -> PlayResult

Where

    enum PlayResult {
        case ActionNotAllowed
        case StillDescending
        case Landed
        case GameOver
    }

## Get Tetrion Information
Other information about the game can be interrogated through the following APIs.

To show a preview of the upcoming tetromino, call `nextPieces`. The type is 
an array of tetrominoes, since some game implementations show a preview of 
multiple pieces. In this implementation, 7 upcoming tetrominoes are returned.
Thus, a preview of up to 7 pieces can be shown.

    game.nextPieces -> [Tetromino]

To get the currently descending tetromino, call `currentPiece`. Although this 
is not strictly needed - since you can simply check the playfield - it's useful
for certain features, such as showing a shadow of the current tetromino.

    game.currentPiece -> Tetromino

To get the current level and score information, call

    game.level -> Int
    game.score -> Int

## Get Game Stats
You can interrogate the game at any time for the current game stats.

    game.stats -> Stats

Where `Stats` is defined as:

    struct Stats {
        // The total number of lines cleared so far in the game
        var totalLinesCleared: Int { get }

        // The total number of tetrises so far in the game
        var totalTetrises: Int { get }

        // The tetris ratio so far in the game
        var tetrisPercentage: Double { get }
    }

# Custom Game Mechanics
`Tetris` represents the tetrion, which is the entire game board, including the
current level, score, next tetromino, and the playfield. Tetris can be initialized
with custom mechanics:

    let game = Tetris(
        startLevel: Int = 1,
        playfieldMechanics: PlayfieldMechanics,
        rotationMechanics: RotationMechanics,
        tetrominoGenerator: TetrominoGenerator,
        scoreCalculator: ScoreCalculator
    )

Where `PlayfieldMechanics` describes the mechanics of the game. The default mechanics
include a 10 x 20 grid.

    protocol PlayfieldMechanics {
        // The width of the playfield in number of blocks. Recommended 10
        val width: Int { get }

        // The height of the playfield in number of blocks. Recommended 20
        val height: Int { get }
    }

Notice that some aspects of gameplay must be provided by the UI. The library does
not take them into account. These include the following:

1. The speed at which tetrominoes fall, based on the current level
1. The lock-delay, which is how long a tetromino is able to move or rotate even
after landing on the floor or on other tetrominoes.

And `TetrominoGenerator` provides the next tetromino. The default generator provides
a random tetromino. However, this can be overridden to provide "hold" behavior, for
instance. It can also be used so that two instances of the game each have the
same tetrominos during gameplay, such as in some tournaments.

    protocol TetrominoGenerator {
        func next() -> Tetromino
    }

And `ScoreCalculator` generates a score delta once a tetromino has landed. The score
can be calculated based on the current level, the number of lines cleared, and the
number of times the player pressed down to drop the tetromino. Points systems more
sophisticated than this are not supported.

    protocol ScoreCalculator {
        getScore(level: Int, linesCleared: Int, numDownPushes: Int) -> Int
    }

And `RotationMechanics` allows you to override where tetrominoes spawn and how
they rotate. The default behavior implements the SRS system.

    public protocol RotationMechanics {

        // A required constructor that allows the game to pass in the dimensions
        // of the playfield. These may be needed in some rotation systems to 
        // implement wall kicks. Note: kicking off other tetrominoes is not
        // supported.
        init(playfieldWidth: Int, playfieldHeight: Int)

        // Given a particular tetromino, returns the coordinates of its
        // four frames representing the spawn location. The game itself doesn't
        // care about the order of the four frames. However, the order may matter
        // to you, as it will make a difference when you implement rotation.
        func getSpawnCoordinates(_ tetromino: Tetromino) -> Coordinates

        // Rotate the given tetromino 90 degrees clockwise. The existing 
        // coordinates and orientation are passed in so the function can accurately
        // provide the new coordinates. It will be up to the game to determine
        // whether the new coordinates are valid or not. You do not have to 
        // check for that -- you rotate the tetromino as if there will be
        // no collisions.
        func rotate(
            _ tetromino: Tetromino, 
            currentCoordinates: Coordinates,
            currentRotation: RotationState
        ) -> Coordinates

    }

Note the definitions

    public typealias Coordinates = [(vertical: Int, horizontal: Int)]

    public enum Orientation {
        case NineOClock // the spawn orientation
        case TwelveOClock
        case ThreeOClock
        case SixOClock
    }
