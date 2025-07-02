public protocol PlayfieldMechanics {
    // The width of the playfield in number of blocks. Recommended 10
    var width: Int { get }

    // The height of the playfield in number of blocks. Recommended 20
    var height: Int { get }
}