class DefaultLevelProgression: LevelProgression {

    func getLevel(currentLevel: Int, totalLinesCleared: Int) -> Int {
        return max(currentLevel, totalLinesCleared / 10)
    }

}