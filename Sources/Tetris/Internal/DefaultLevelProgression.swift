class DefaultLevelProgression: LevelProgression {

    func getLevel(currentLevel: Int, totalLinesCleared: Int) -> Int {
        max(currentLevel, totalLinesCleared / 10)
    }

}