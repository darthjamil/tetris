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
    private let tetrominoGenerator: TetrominoGenerator
    private let scoreCalculator: ScoreCalculator
    private var totalLinesCleared = 0
    private var totalTetrises = 0
    private var tetrisPercentage = 0.0
    // The location of each block of the current tetromino
    private var block1 = (vertical: 0, horizontal: 0)
    private var block2 = (vertical: 0, horizontal: 0)
    private var block3 = (vertical: 0, horizontal: 0)
    private var block4 = (vertical: 0, horizontal: 0)

    convenience init(startLevel: Int = 1) {
        self.init(
            startLevel: startLevel,
            DefaultPlayfieldMechanics(), 
            DefaultTetrominoGenerator(),
            NintendoScoreCalculator())
    }

    init(
        startLevel: Int = 1,
        _ playfieldMechanics: PlayfieldMechanics,
        _ tetrominoGenerator: TetrominoGenerator,
        _ scoreCalculator: ScoreCalculator
    ) {
        self.playfieldMechanics = playfieldMechanics
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
        // TODO
        .StillDescending
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
        nextPieces.insert(newPiece, at: 0)

        placeOnPlayfield(tetromino: currentPiece)
    }

    private func placeOnPlayfield(tetromino: Tetromino) {
        let coordinates = switch tetromino {
            case .I:
                TetrominoInitializer.placeI(playfieldWidth: playfieldMechanics.width)
            case .J:
                TetrominoInitializer.placeJ(playfieldWidth: playfieldMechanics.width)
            case .L:
                TetrominoInitializer.placeL(playfieldWidth: playfieldMechanics.width)
            case .O:
                TetrominoInitializer.placeO(playfieldWidth: playfieldMechanics.width)
            case .S:
                TetrominoInitializer.placeS(playfieldWidth: playfieldMechanics.width)
            case .Z:
                TetrominoInitializer.placeZ(playfieldWidth: playfieldMechanics.width)
            case .T:
                TetrominoInitializer.placeT(playfieldWidth: playfieldMechanics.width)
        }

        placeOnPlayfield(tetromino, coordinates: coordinates)
    }

    private func placeOnPlayfield(_ tetromino: Tetromino, coordinates: [(vertical: Int, horizontal: Int)]) {
        for coordinate in coordinates {
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

    private func touchesLeftWall(_ horizontal: Int) -> Bool { horizontal <= 0 }

    private func touchesLeftWall() -> Bool {
        touchesLeftWall(block1.horizontal)
            || touchesLeftWall(block2.horizontal)
            || touchesLeftWall(block3.horizontal)
            || touchesLeftWall(block4.horizontal)
    }

    private func isOccupiedLeft() -> Bool {
        isOccupied(block1.vertical, block1.horizontal - 1)
            || isOccupied(block2.vertical, block2.horizontal - 1)
            || isOccupied(block3.vertical, block3.horizontal - 1)
            || isOccupied(block4.vertical, block4.horizontal - 1)
    }

    private func touchesRightWall(_ horizontal: Int) -> Bool { horizontal >= playfieldMechanics.width - 1 }

    private func touchesRightWall() -> Bool {
        touchesRightWall(block1.horizontal)
            || touchesRightWall(block2.horizontal)
            || touchesRightWall(block3.horizontal)
            || touchesRightWall(block4.horizontal)
    }

    private func isOccupiedRight() -> Bool {
        isOccupied(block1.vertical, block1.horizontal + 1)
            || isOccupied(block2.vertical, block2.horizontal + 1)
            || isOccupied(block3.vertical, block3.horizontal + 1)
            || isOccupied(block4.vertical, block4.horizontal + 1)
    }

    private func touchesTop(_ vertical: Int) -> Bool { vertical <= 0 }

    private func touchesTop() -> Bool {
        touchesTop(block1.vertical)
            || touchesTop(block2.vertical)
            || touchesTop(block3.vertical)
            || touchesTop(block4.vertical)
    }

    private func touchesFloor(_ vertical: Int) -> Bool { vertical >= playfieldMechanics.height - 1 }

    private func touchesFloor() -> Bool {
        touchesFloor(block1.vertical)
            || touchesFloor(block2.vertical)
            || touchesFloor(block3.vertical)
            || touchesFloor(block4.vertical)
    }

    private func hasLanded() -> Bool {
        isOccupied(block1.vertical + 1, block1.horizontal)
            || isOccupied(block2.vertical + 1, block2.horizontal)
            || isOccupied(block3.vertical + 1, block3.horizontal)
            || isOccupied(block4.vertical + 1, block4.horizontal)
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
        playfield[block1.vertical][block1.horizontal] = nil
        playfield[block2.vertical][block2.horizontal] = nil
        playfield[block3.vertical][block3.horizontal] = nil
        playfield[block4.vertical][block4.horizontal] = nil

        block1 = (block1.vertical + verticallyBy, block1.horizontal + horizontallyBy)
        block1 = (block2.vertical + verticallyBy, block2.horizontal + horizontallyBy)
        block1 = (block3.vertical + verticallyBy, block3.horizontal + horizontallyBy)
        block1 = (block4.vertical + verticallyBy, block4.horizontal + horizontallyBy)

        playfield[block1.vertical][block1.horizontal] = currentPiece
        playfield[block2.vertical][block2.horizontal] = currentPiece
        playfield[block3.vertical][block3.horizontal] = currentPiece
        playfield[block4.vertical][block4.horizontal] = currentPiece
    }

}