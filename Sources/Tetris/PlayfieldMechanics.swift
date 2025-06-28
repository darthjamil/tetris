public protocol PlayfieldMechanics {
    // The width of the playfield in number of blocks. Recommended 10
    var width: Int { get }

    // The height of the playfield in number of blocks. Recommended 20
    var height: Int { get }

    // Whether or not wall kicks are allowed when rotating a tetromino too
    // close to a wall. This does not apply if the tetromino is too close to
    // another piece or the floor.
    var allowWallKicks: Bool { get }
}