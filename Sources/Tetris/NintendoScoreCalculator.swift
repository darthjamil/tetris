class NintendoScoreCalculator: ScoreCalculator {

    func getScore(level: Int, linesCleared: Int, numDownPushes: Int, linesHardDropped: Int) -> Int {
        let lineClearScore = switch linesCleared {
            case 1: 40 * (level + 1)
            case 2: 100 * (level + 1)
            case 3: 300 * (level + 1)
            case 4: 1200 * (level + 1)
            default: 0
        }

        return lineClearScore + numDownPushes
    }

}