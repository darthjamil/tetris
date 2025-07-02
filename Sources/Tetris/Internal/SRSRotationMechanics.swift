class SRSRotationMechanics: RotationMechanics {

    private let width: Int
    private let height: Int

    required init(playfieldWidth: Int, playfieldHeight: Int) {
        self.width = playfieldWidth
        self.height = playfieldHeight
    }

    func getSpawnCoordinates(_ tetromino: Tetromino) -> Coordinates{
        switch tetromino {
            case .I: return spawnI()
            case .J: return spawnJ()
            case .L: return spawnL()
            case .O: return spawnO()
            case .S: return spawnS()
            case .Z: return spawnZ()
            case .T: return spawnT()
        }
    }

    func rotate(
        _ tetromino: Tetromino, 
        currentCoordinates: Coordinates,
        currentRotation: Orientation
    ) -> Coordinates {
        switch tetromino {
            case .I: return rotateI(currentCoordinates, currentRotation)
            case .J: return rotateJ(currentCoordinates, currentRotation)
            case .L: return rotateL(currentCoordinates, currentRotation)
            case .O: return rotateO(currentCoordinates)
            case .S: return rotateS(currentCoordinates, currentRotation)
            case .Z: return rotateZ(currentCoordinates, currentRotation)
            case .T: return rotateT(currentCoordinates, currentRotation)
        }
    }

    /* 
    This is (or should be) the only place in the application that cares
    about the exact position of each frame of a tetromino. It's also the
    only place in the app that should switch on (or subclass on) tetromino
    type -- no other action should need to know the type of tetromino
    other than spawning and rotating.

    Be careful, the coordinates of each frame are returned as an array
    of y,x tuples. The order of the tuples in this array is important.
    Assumptions are made about the order in order to make rotation
    much easier to deal with.
    */

    private func spawnI() -> Coordinates {
        let startIndex = (width - 4) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (0, startIndex + 2), 
                (0, startIndex + 3)]
    }

    private func rotateI(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal + 2), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical + 1, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 2, currentCoordinates[3].horizontal - 1)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 2, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal - 1), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal - 2)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal - 2), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical - 1, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 2, currentCoordinates[3].horizontal + 1)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 2, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal + 1), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal + 2)]
        }
    }

    private func spawnJ() -> Coordinates {
        let startIndex = (width - 3) / 2
        return [(0, startIndex), 
                (1, startIndex), 
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

    private func rotateJ(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical, currentCoordinates[0].horizontal + 2), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal - 1)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 2, currentCoordinates[0].horizontal), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal - 1)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical, currentCoordinates[0].horizontal - 2), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal + 1)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 2, currentCoordinates[0].horizontal), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal + 1)]
        }
    }
    
    private func spawnL() -> Coordinates {
        let startIndex = (width - 3) / 2
        return [(1, startIndex), 
                (1, startIndex + 1), 
                (1, startIndex + 2),
                (0, startIndex + 2)]
    }

    private func rotateL(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical + 1, currentCoordinates[2].horizontal - 1), 
                 (currentCoordinates[3].vertical + 2, currentCoordinates[3].horizontal)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical - 1, currentCoordinates[2].horizontal - 1), 
                 (currentCoordinates[3].vertical, currentCoordinates[3].horizontal - 2)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical - 1, currentCoordinates[2].horizontal + 1), 
                 (currentCoordinates[3].vertical - 2, currentCoordinates[3].horizontal)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical + 1, currentCoordinates[2].horizontal + 1), 
                 (currentCoordinates[3].vertical, currentCoordinates[3].horizontal + 2)]
        }
    }

    private func spawnO() -> Coordinates {
        let startIndex = (width - 2) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (1, startIndex), 
                (1, startIndex + 1)]
    }

    private func rotateO(_ currentCoordinates: Coordinates) -> Coordinates {
        return currentCoordinates
    }

    private func spawnS() -> Coordinates {
        let startIndex = (width - 4) / 2
        return [(1, startIndex), 
                (1, startIndex + 1),
                (0, startIndex + 1), 
                (0, startIndex + 2)]
    }

    private func rotateS(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical + 1, currentCoordinates[2].horizontal + 1), 
                 (currentCoordinates[3].vertical + 2, currentCoordinates[3].horizontal)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical + 1, currentCoordinates[2].horizontal - 1), 
                 (currentCoordinates[3].vertical, currentCoordinates[3].horizontal - 2)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical - 1, currentCoordinates[2].horizontal - 1), 
                 (currentCoordinates[3].vertical - 2, currentCoordinates[3].horizontal)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical, currentCoordinates[1].horizontal), 
                 (currentCoordinates[2].vertical - 1, currentCoordinates[2].horizontal + 1), 
                 (currentCoordinates[3].vertical, currentCoordinates[3].horizontal + 2)]
        }
    }
    
    private func spawnZ() -> Coordinates {
        let startIndex = (width - 4) / 2
        return [(0, startIndex), 
                (0, startIndex + 1), 
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

    private func rotateZ(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical, currentCoordinates[0].horizontal + 2), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal - 1)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 2, currentCoordinates[0].horizontal), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal - 1)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical, currentCoordinates[0].horizontal - 2), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal + 1)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 2, currentCoordinates[0].horizontal), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal + 1)]
        }
    }

    private func spawnT() -> Coordinates {
        let startIndex = (width - 3) / 2
        return [(1, startIndex), 
                (0, startIndex + 1),
                (1, startIndex + 1), 
                (1, startIndex + 2)]
    }

    private func rotateT(_ currentCoordinates: Coordinates, _ currentRotation: Orientation) -> Coordinates {
        switch currentRotation {
            case .NineOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal - 1)]
            case .TwelveOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal + 1), 
                 (currentCoordinates[1].vertical + 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal - 1)]
            case .ThreeOClock: return 
                [(currentCoordinates[0].vertical + 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal - 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical - 1, currentCoordinates[3].horizontal + 1)]
            case .SixOClock: return 
                [(currentCoordinates[0].vertical - 1, currentCoordinates[0].horizontal - 1), 
                 (currentCoordinates[1].vertical - 1, currentCoordinates[1].horizontal + 1), 
                 (currentCoordinates[2].vertical, currentCoordinates[2].horizontal), 
                 (currentCoordinates[3].vertical + 1, currentCoordinates[3].horizontal + 1)]
        }
    }
    
}