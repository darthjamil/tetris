public class Tetris {

    private(set) var currentPiece: Tetromino
    private(set) var nextPieces: [Tetromino]
    private(set) var playfield: [[Tetromino?]]
    private(set) var level: Int
    private(set) var score = 0

    var stats: Stats {
        return Stats(totalLinesCleared: totalLinesCleared, totalTetrises: totalTetrises, tetrisPercentage: tetrisPercentage)
    }

    let playfieldMechanics: PlayfieldMechanics
    let tetrominoGenerator: TetrominoGenerator
    let scoreCalculator: ScoreCalculator
    let maxNextPieces = 7

    private var totalLinesCleared = 0
    private var totalTetrises = 0
    private var tetrisPercentage = 0.0

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

        self.level = startLevel

        self.currentPiece = tetrominoGenerator.next()
        self.nextPieces = Array((1...maxNextPieces).map { _ in tetrominoGenerator.next() })

        self.playfield = Array(
            repeating: [Tetromino?](repeating: nil, count: playfieldMechanics.width), 
            count: playfieldMechanics.height)
    }

    func rotate() -> Bool {
        return false
    }

    func left() -> Bool {
        return false
    }

    func right() -> Bool {
        return false
    }

    func down() -> DropResult {
        return .StillDescending(scoreDelta: 0)
    }

    func drop() -> DropResult {
        return .Landed(linesCleared: 0, scoreDelta: 0)
    }

}