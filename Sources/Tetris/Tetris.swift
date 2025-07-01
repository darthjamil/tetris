public final class Tetris {

    private(set) var currentPiece: Tetromino
    private(set) var nextPieces: [Tetromino]
    private(set) var playfield: [[Tetromino?]]
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
    private var frames = [(vertical: Int, horizontal: Int)]()
    // Orientation of the current tetromino
    private var rotationState = RotationState.NineOClock

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
        self.playfield = Array(
            repeating: [Tetromino?](repeating: nil, count: playfieldMechanics.width), 
            count: playfieldMechanics.height)
    }

    func rotate() -> PlayResult {
        let newCoordinates = rotationMechanics.rotate(
            currentPiece, currentCoordinates: frames, currentRotation: rotationState)

        if newCoordinates.contains { c in isOutOfBounds(c.vertical, c.horizontal) } {
            return .ActionNotAllowed
        }

        if newCoordinates.contains { c in 
            !belongsToCurrentPiece(c.vertical, c.horizontal) && isOccupied(c.vertical, c.horizontal)
        } {
            return .ActionNotAllowed
        }

        frames.forEach { frame in
            playfield[frame.vertical][frame.horizontal] = nil
        }

        frames = newCoordinates

        frames.forEach { frame in
            playfield[frame.vertical][frame.horizontal] = currentPiece
        }

        rotationState.rotateClockwise()

        if touchesFloor() || hasLanded() {
            updateStats()
            startNextPiece()
            return .Landed
        }

        return .StillDescending
    }

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

        return .Landed
    }

    private func updateStats() {
        // TODO: increase score; advance level; update stats
        score += scoreCalculator.getScore(
            level: level, linesCleared: 0, numDownPushes: 0)
    }

    private func startNextPiece() {
        let nextCurrentPiece = nextPieces.popLast()!
        let newPiece = tetrominoGenerator.next()

        currentPiece = nextCurrentPiece
        rotationState = .NineOClock
        nextPieces.insert(newPiece, at: 0)

        spawnTetromino(tetromino: currentPiece)
    }

    private func spawnTetromino(tetromino: Tetromino) {
        let coordinates = rotationMechanics.getSpawnCoordinates(tetromino)

        frames = coordinates

        for coordinate in frames {
            playfield[coordinate.vertical][coordinate.horizontal] = tetromino
        }
    }

    private func isOutOfBounds(_ vertical: Int, _ horizontal: Int) -> Bool {
        vertical < 0 
            || vertical > playfieldMechanics.height - 1 
            || horizontal < 0
            || horizontal > playfieldMechanics.width - 1
    }

    private func isOccupied(_ vertical: Int, _ horizontal: Int) -> Bool {
        isOutOfBounds(vertical, horizontal)
            || playfield[vertical][horizontal] != nil
    }

    private func belongsToCurrentPiece(_ vertical: Int, _ horizontal: Int) -> Bool {
        frames.contains { frame in
            vertical == frame.vertical && horizontal == frame.horizontal
        }
    }

    private func touchesLeftWall(_ horizontal: Int) -> Bool { horizontal <= 0 }

    private func touchesLeftWall() -> Bool {
        frames.contains { frame in touchesLeftWall(frame.horizontal) }
    }

    private func isOccupiedLeft() -> Bool {
        frames.contains { frame in 
            !belongsToCurrentPiece(frame.vertical, frame.horizontal - 1)
                && isOccupied(frame.vertical, frame.horizontal - 1)
        }
    }

    private func touchesRightWall(_ horizontal: Int) -> Bool { horizontal >= playfieldMechanics.width - 1 }

    private func touchesRightWall() -> Bool {
        frames.contains { frame in touchesRightWall(frame.horizontal) }
    }

    private func isOccupiedRight() -> Bool {
        frames.contains { frame in 
            !belongsToCurrentPiece(frame.vertical, frame.horizontal + 1)
                && isOccupied(frame.vertical, frame.horizontal + 1)
        }
    }

    private func touchesTop(_ vertical: Int) -> Bool { vertical <= 0 }

    private func touchesTop() -> Bool {
        frames.contains { frame in touchesTop(frame.vertical) }
    }

    private func touchesFloor(_ vertical: Int) -> Bool { vertical >= playfieldMechanics.height - 1 }

    private func touchesFloor() -> Bool {
        frames.contains { frame in touchesFloor(frame.vertical) }
    }

    private func hasLanded() -> Bool {
        frames.contains { frame in 
            !belongsToCurrentPiece(frame.vertical + 1, frame.horizontal)
                && isOccupied(frame.vertical + 1, frame.horizontal)
        }
    }

    private func moveLeft() {
        translateCurrentPiece(horizontallyBy: -1)
    }

    private func moveRight() {
        translateCurrentPiece(horizontallyBy: +1)
    }

    private func moveDown() {
        translateCurrentPiece(verticallyBy: +1)
    }

    private func translateCurrentPiece(verticallyBy: Int = 0, horizontallyBy: Int = 0) {
        frames.forEach { frame in
            playfield[frame.vertical][frame.horizontal] = nil
        }

        for (i, frame) in frames.enumerated() {
            frames[i] = (frame.vertical + verticallyBy, frame.horizontal + horizontallyBy)
        }

        frames.forEach { frame in
            playfield[frame.vertical][frame.horizontal] = currentPiece
        }
    }

}