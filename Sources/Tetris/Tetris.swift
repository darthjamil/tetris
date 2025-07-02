public final class Tetris {

    private(set) var currentPiece: Tetromino
    private(set) var nextPieces: [Tetromino]
    private(set) var playfield: Playfield
    private(set) var level: Int
    private(set) var score = 0

    var stats: Stats {
        Stats(
            totalLinesCleared: totalLinesCleared, 
            totalTetrises: totalTetrises, 
            tetrisPercentage: tetrisPercentage)
    }

    private let maxNextPieces = 7
    private let playfieldMechanics: PlayfieldMechanics
    private let rotationMechanics: RotationMechanics
    private let tetrominoGenerator: TetrominoGenerator
    private let scoreCalculator: ScoreCalculator
    private var totalLinesCleared = 0
    private var totalTetrises = 0
    private var tetrisPercentage = 0.0
    // Coordinates for each frame of the current tetromino
    private var coordinates = Coordinates()
    // Orientation of the current tetromino
    private var orientation = Orientation.NineOClock

    convenience init(startLevel: Int = 1) {
        let playfieldMechanics = DefaultPlayfieldMechanics()
        self.init(
            startLevel: startLevel,
            DefaultPlayfieldMechanics(), 
            SRSRotationMechanics(
                playfieldWidth: playfieldMechanics.width, 
                playfieldHeight: playfieldMechanics.height),
            DefaultTetrominoGenerator(),
            NintendoScoreCalculator())
    }

    init(
        startLevel: Int = 1,
        _ playfieldMechanics: PlayfieldMechanics,
        _ rotationMechanics: RotationMechanics,
        _ tetrominoGenerator: TetrominoGenerator,
        _ scoreCalculator: ScoreCalculator
    ) {
        self.playfieldMechanics = playfieldMechanics
        self.rotationMechanics = rotationMechanics
        self.tetrominoGenerator = tetrominoGenerator
        self.scoreCalculator = scoreCalculator
        self.level = max(1, startLevel)
        self.currentPiece = tetrominoGenerator.next()
        self.nextPieces = Array((1...maxNextPieces).map { _ in tetrominoGenerator.next() })
        self.playfield = Playfield(width: playfieldMechanics.width, height: playfieldMechanics.height)

        startNextPiece()
    }

    private func startNextPiece() {
        let nextCurrentPiece = nextPieces.popLast()!
        let newPiece = tetrominoGenerator.next()

        currentPiece = nextCurrentPiece
        coordinates = rotationMechanics.getSpawnCoordinates(nextCurrentPiece)
        orientation = .NineOClock
        nextPieces.insert(newPiece, at: 0)
        
        playfield.spawn(nextCurrentPiece, at: coordinates)
    }

    private func updateStats() {
        // TODO: increase score; advance level; update stats
        score += scoreCalculator.getScore(
            level: level, linesCleared: 0, numDownPushes: 0)
    }

    func rotate() -> PlayResult {
        let newCoordinates = rotationMechanics.rotate(
            currentPiece, currentCoordinates: coordinates, currentRotation: orientation)

        if playfield.isAnyOutOfBounds(newCoordinates) {
            return .ActionNotAllowed
        }

        if playfield.isAnyOccupied(new: newCoordinates, old: coordinates) {
            return .ActionNotAllowed
        }

        playfield.move(currentPiece, at: coordinates, to: newCoordinates)
        coordinates = newCoordinates
        orientation.rotateClockwise()

        if playfield.isPlayfieldFull() {
            updateStats()
            return .GameOver
        }

        if playfield.touchesFloor(newCoordinates) {
            updateStats()
            startNextPiece()
            return .Landed
        }

        return .StillDescending
    }
/*
    func left() -> PlayResult {
        if touchesLeftWall() || isOccupiedLeft() {
            return .ActionNotAllowed
        }

        moveLeft()

        if touchesFloor() || hasLanded() {
            updateStats()
            startNextPiece()
            return .Landed
        }

        return .StillDescending
    }

    func right() -> PlayResult {
        if touchesRightWall() || isOccupiedRight() {
            return .ActionNotAllowed
        }

        moveRight()

        if touchesFloor() || hasLanded() {
            updateStats()
            startNextPiece()
            return .Landed
        }

        return .StillDescending
    }

    func down() -> PlayResult {
        if touchesFloor() || hasLanded() {
            return .Landed
        }

        moveDown()

        if touchesFloor() || hasLanded() {
            updateStats()
            startNextPiece()
            return .Landed
        }

        return .StillDescending
    }

    func drop() -> PlayResult {
        var result: PlayResult
        repeat {
            result = down()
        } while result == .StillDescending

        return result
    }
*/
}