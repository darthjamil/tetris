public protocol RotationMechanics {

    func getSpawnCoordinates(_ tetromino: Tetromino) -> Coordinates
    func rotate(
        _ tetromino: Tetromino, 
        currentCoordinates: Coordinates,
        currentRotation: Orientation
    ) -> Coordinates

}