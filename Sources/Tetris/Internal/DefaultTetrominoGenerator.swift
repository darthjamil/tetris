class DefaultTetrominoGenerator: TetrominoGenerator {

    func next() -> Tetromino {
        Tetromino.allCases.randomElement()!
    }
    
}