public protocol ScoreCalculator {
    func getScore(
        level: Int, 
        linesCleared: Int, 
        numDownPushes: Int
    ) -> Int
}