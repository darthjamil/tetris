public protocol LevelProgression {
    func getLevel(currentLevel: Int, totalLinesCleared: Int) -> Int
}