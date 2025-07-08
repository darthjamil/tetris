/*
Defines where on a clock face the first frame in a tetromino's
coordinates array is pointing.
*/
public enum Orientation {
    case nineOClock
    case twelveOClock
    case threeOClock
    case sixOClock

    mutating func rotateClockwise() {
        switch self {
            case .nineOClock: self = .twelveOClock
            case .twelveOClock: self = .threeOClock
            case .threeOClock: self = .sixOClock
            case .sixOClock: self = .nineOClock
        }
    }
}