/*
For each tetromino, returns the coordinates to place it on the board.
The coordinates are provided as an array (of size 4) of tuples, each
with a vertical and horizontal coordinate.
*/
struct TetrominoInitializer {

    static func placeI(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 4) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (0, startIndex + 2), 
                (0, startIndex + 3)]
    }

    static func placeJ(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 3) / 2
        return [(0, startIndex), 
                (1, startIndex), 
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

    static func placeL(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 3) / 2
        return [(0, startIndex + 2), 
                (1, startIndex + 2), 
                (1, startIndex + 1), 
                (1, startIndex)]
    }

    static func placeO(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 2) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (1, startIndex), 
                (1, startIndex + 1)]
    }

    static func placeS(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 4) / 2
        return [(0, startIndex + 1), 
                (0, startIndex + 2), 
                (1, startIndex), 
                (1, startIndex + 1)]
    }

    static func placeZ(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 4) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

    static func placeT(playfieldWidth: Int) -> [(vertical: Int, horizontal: Int)] {
        let startIndex = (playfieldWidth - 3) / 2
        return [(0, startIndex + 1), 
                (1, startIndex), 
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

}