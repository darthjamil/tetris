# Tetris
This is Tetris implemented in Swift.

For details on how to play Tetris, terminology, and game mechanics, see 
[the Tetris Wiki](https://tetris.fandom.com/wiki/Tetris_Wiki).

# API & Usage
The codebase is broken up into the core game engine and a UI on top of it. 

The engine can be used to play Tetris programmatically, without a UI. To start
playing with the engine, first initialize the game:

    let game = Tetris()

The game can also be initialized with custom mechanics. More on this later.

Then start the game. This will cause tetrominoes to start falling. You must also
pass a callback that will be invoked regularly. The callback will contain updated
game information, including a 2D array that can be used to re-render the playfield.

    game.start(startLevel: 18) { gameState in
        // do something
    }

Where `gameState` is defined as

    protocol GameState {
        var level: Int { get }
        var score: Long { get }
        var nextPiece: [Tetromino] { get }
        var playfield: [[Int]] { get }
        var stats: Stats { get }
    }

    protocol Stats {
        // Whether the latest update resulted in a tetris
        var isTetris: Bool { get }

        // Which lines of the playfield, zero-indexed from the bottom,
        // were cleared in the latest update
        var linesCleared: [Int] { get }

        // The total number of lines cleared so far in the game
        var totalLinesCleared: Long { get }

        // The total number of tetrises so far in the game
        var totalTetrises: Long { get }

        // The tetris ratio so far in the game
        var tetrisPercentage: Double { get }
    }

    enum Tetromino {
        L, J, S, Z, T, I
    }

The game will not stop until you have lost. To force a stop (for testing purposes),
you can call

    game.kill()

To play the game, you call the following APIs

    game.left() -> Bool
    game.right() -> Bool
    game.down() -> Bool
    game.drop()
    game.rotate() -> Bool

These methods move the currently descending tetromino left, right, one space down,
or drop it, or rotate it 90 degrees, respectively. Although the `gameState` can be
interrogated to find the new configuration of the playfield, these methods return
whether the move was a success or not, for convenience purposes. For example, a UI
may want to have a visual or audio indicator that a move was illegal, without having
to diff the playfield.

# Custom Game Mechanics
`Tetris` represents the tetrion, which is the entire game board, including the
current level, score, next tetromino, and the playfield. Tetris can be initialized
with custom mechanics:

    let game = Tetris(
        playfieldMechanics: PlayfieldMechanics,
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

        // The speed at which a tetromino falls naturally, measured in G's, or 
        // frames per second. Recommended 1G = 1 grid cell per second for level
        // 18 and lower.
        func getGravity(level: Int) -> Double

        // The amount of time, in seconds, a tetromino can move despite having
        // landed on the floor or other tetrominoes. Recommended 0 to 0.5 sec
        val lockDelay: Double { get }

        // Whether or not wall kicks are allowed when rotating a tetromino too
        // close to a wall. This does not apply if the tetromino is too close to
        // another piece or the floor.
        val allowWallKicks: Bool { get }
    }

And `TetrominoGenerator` provides the next tetromino. The default generator provides
a random tetromino. However, this can be overridden to provide "hold" behavior, for
instance. It can also be overridden so that two instances of the game each have the
same tetrominos during gameplay, such as in some tournaments.

    protocol TetrominoGenerator {
        func next() -> Tetromino
    }

And `ScoreCalculator` generates a score delta once a tetromino has landed. The score
can be calculated based on the current level, the number of lines cleared, and the
number of times the player pressed down to drop the tetromino. Points systems more
sophisticated than this are not supported.

    protocol ScoreCalculator {
        func getScore(
            level: Int,
            linesCleared: Int,
            downPushes: Int
        ) -> Long
    }
