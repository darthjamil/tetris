public struct Stats {
    // The total number of lines cleared so far in the game
    private(set) var totalLinesCleared: Int = 0

    // The total number of tetrises so far in the game
    private(set) var totalTetrises: Int = 0

    // The tetris ratio so far in the game
    private(set) var tetrisPercentage: Double = 0
}