public final class Tetris {

    private(set) var currentPiece: Tetromino
    private(set) var nextPieces: [Tetromino]
    private(set) var level: Int
    private(set) var score = 0

    var stats: Stats {
        Stats(
            totalLinesCleared: totalLinesCleared, 
            totalTetrises: totalTetrises, 
            tetrisPercentage: tetrisPercentage)
    }

    var board: [[Tetromino?]] {
        playfield.grid
    }

    private let maxNextPieces = 7
    private let playfieldOverrides: PlayfieldOverrides
    private let rotationMechanics: RotationMechanics
    private let tetrominoGenerator: TetrominoGenerator
    private let scoreCalculator: ScoreCalculator
    private let levelProgression: LevelProgression
    private var playfield: Playfield
    private var totalLinesCleared = 0
    private var totalTetrises = 0
    private var numDownPresses = 0
    private var numLinesCleared = 0
    private var tetrisPercentage: Double {
        totalLinesCleared > 0 ? Double(totalTetrises) / Double(totalLinesCleared) : 0
    }
    // Coordinates for each frame of the current tetromino
    private var coordinates = Coordinates()
    // Orientation of the current tetromino
    private var orientation = Orientation.NineOClock

    convenience init(startLevel: Int = 1) {
        let playfieldMechanics = DefaultPlayfieldOverrides()
        self.init(
            startLevel: startLevel,
            DefaultPlayfieldOverrides(), 
            SRSRotationMechanics(
                playfieldWidth: playfieldMechanics.width, 
                playfieldHeight: playfieldMechanics.height),
            DefaultTetrominoGenerator(),
            NintendoScoreCalculator(),
            DefaultLevelProgression())
    }

    init(
        startLevel: Int = 1,
        _ playfieldOverrides: PlayfieldOverrides,
        _ rotationMechanics: RotationMechanics,
        _ tetrominoGenerator: TetrominoGenerator,
        _ scoreCalculator: ScoreCalculator,
        _ levelProgression: LevelProgression
    ) {
        self.playfieldOverrides = playfieldOverrides
        self.rotationMechanics = rotationMechanics
        self.tetrominoGenerator = tetrominoGenerator
        self.scoreCalculator = scoreCalculator
        self.levelProgression = levelProgression
        self.level = max(1, startLevel)
        self.currentPiece = tetrominoGenerator.next()
        self.nextPieces = Array((1...maxNextPieces).map { _ in tetrominoGenerator.next() })
        self.playfield = Playfield(width: playfieldOverrides.width, height: playfieldOverrides.height)

        startNextPiece()
    }

    func startNextPiece() {
        let nextCurrentPiece = nextPieces.popLast()!
        let newPiece = tetrominoGenerator.next()

        currentPiece = nextCurrentPiece
        coordinates = rotationMechanics.getSpawnCoordinates(nextCurrentPiece)
        orientation = .NineOClock
        nextPieces.insert(newPiece, at: 0)
        
        playfield.spawn(nextCurrentPiece, at: coordinates)
    }

    func rotate() -> PlayResult {
        let newCoordinates = rotationMechanics.rotate(
            currentPiece, currentCoordinates: coordinates, currentRotation: orientation)

        let result = move(to: newCoordinates)

        if result != .ActionNotAllowed {
            orientation.rotateClockwise()
        }

        return result
    }

    func left() -> PlayResult {
        let newCoordinates = coordinates.map { (v, h) in (v, h - 1) }
        let result = move(to: newCoordinates)

        return result
    }

    func right() -> PlayResult {
        let newCoordinates = coordinates.map { (v, h) in (v, h + 1) }
        let result = move(to: newCoordinates)

        return result
    }

    func down() -> PlayResult {
        let newCoordinates = coordinates.map { (v, h) in (v + 1, h) }
        let result = move(to: newCoordinates)

        numDownPresses += 1

        return result
    }

    func drop() -> PlayResult {
        var result: PlayResult
        repeat {
            result = down()
        } while result == .StillDescending

        return result
    }

    private func move(to newCoordinates: Coordinates) -> PlayResult {
        if playfield.isAnyOutOfBounds(newCoordinates) {
            return .ActionNotAllowed
        }

        if playfield.isAnyOccupied(new: newCoordinates, old: coordinates) {
            return .ActionNotAllowed
        }

        playfield.move(currentPiece, at: coordinates, to: newCoordinates)
        coordinates = newCoordinates

        if playfield.hasLanded(coordinates) {
            let completeRows = playfield.getCompleteRows()

            if !completeRows.isEmpty {
                playfield.clearRows(completeRows)
                numLinesCleared = completeRows.count
                updateStats()
                return .Landed
            }

            if playfield.isPlayfieldFull() {
                updateStats()
                return .GameOver
            }
        }
        
        return .StillDescending
    }

    private func updateStats() {
        defer {
            numDownPresses = 0
            numLinesCleared = 0
        }

        totalLinesCleared += numLinesCleared
        totalTetrises += numLinesCleared >= 4 ? 1 : 0
        score += scoreCalculator.getScore(
            level: level, linesCleared: numLinesCleared, numDownPushes: numDownPresses)
        
        level = levelProgression.getLevel(currentLevel: level, totalLinesCleared: totalLinesCleared)
    }

}