/*
Defines where on a clock face the first frame in a tetromino's
coordinates array is pointing.
*/
public enum Orientation {
    case NineOClock
    case TwelveOClock
    case ThreeOClock
    case SixOClock

    mutating func rotateClockwise() {
        switch self {
            case .NineOClock: self = .TwelveOClock
            case .TwelveOClock: self = .ThreeOClock
            case .ThreeOClock: self = .SixOClock
            case .SixOClock: self = .NineOClock
        }
    }
}