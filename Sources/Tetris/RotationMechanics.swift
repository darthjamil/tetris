public protocol RotationMechanics {

    init(playfieldWidth: Int, playfieldHeight: Int)
    func getSpawnCoordinates(_ tetromino: Tetromino) -> Coordinates
    func rotate(
        _ tetromino: Tetromino, 
        currentCoordinates: Coordinates,
        currentRotation: Orientation
    ) -> Coordinates

}