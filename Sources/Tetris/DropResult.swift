public enum DropResult {
    case StillDescending(scoreDelta: Int)
    case Landed(linesCleared: Int, scoreDelta: Int)
}