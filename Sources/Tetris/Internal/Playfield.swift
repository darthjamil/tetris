class Playfield {

    private let width: Int
    private let height: Int
    private(set) var grid: [[Tetromino?]]

    required init(width: Int, height: Int) {
        self.width = width
        self.height = height

        self.grid = Array(
            repeating: [Tetromino?](repeating: nil, count: width), 
            count: height)
    }

    func isOutOfBounds(vertical: Int, horizontal: Int) -> Bool {
        vertical < 0 
            || vertical > height - 1 
            || horizontal < 0
            || horizontal > width - 1
    }

    func isAnyOutOfBounds(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            isOutOfBounds(vertical: v, horizontal: h)
        }
    }

    func isOccupied(vertical: Int, horizontal: Int) -> Bool {
        isOutOfBounds(vertical: vertical, horizontal: horizontal)
            || grid[vertical][horizontal] != nil
    }

    func isAnyOccupied(new: Coordinates, old: Coordinates) -> Bool {
        new.contains { (v, h) in
            !old.contains(vertical: v, horizontal: h)
            && isOccupied(vertical: v, horizontal: h)
        }
    }

    func isOccupiedLeft(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            !coordinates.contains(vertical: v, horizontal: h - 1)
            && isOccupied(vertical: v, horizontal: h - 1)
        }
    }

    func isOccupiedRight(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            !coordinates.contains(vertical: v, horizontal: h + 1)
            && isOccupied(vertical: v, horizontal: h + 1)
        }
    }

    func isOccupiedBelow(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            !coordinates.contains(vertical: v + 1, horizontal: h)
            && isOccupied(vertical: v + 1, horizontal: h)
        }
    }

    func touchesLeftWall(_ horizontal: Int) -> Bool { 
        horizontal <= 0 
    }

    func touchesLeftWall(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            touchesLeftWall(h)
        }
    }

    func touchesRightWall(_ horizontal: Int) -> Bool { 
        horizontal >= width - 1 
    }

    func touchesRightWall(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            touchesRightWall(h)
        }
    }

    func touchesTop(_ vertical: Int) -> Bool { 
        vertical <= 0 
    }

    func touchesTop(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            touchesTop(v)
        }
    }

    func touchesFloor(_ vertical: Int) -> Bool { 
        vertical >= height - 1 
    }

    func touchesFloor(_ coordinates: Coordinates) -> Bool {
        coordinates.contains { (v, h) in
            touchesFloor(v)
        }
    }

    func hasLanded(_ coordinates: Coordinates) -> Bool {
        touchesFloor(coordinates) || isOccupiedBelow(coordinates)
    }

    func isPlayfieldFull() -> Bool {
        grid.allSatisfy { row in
            row.contains { cell in cell != nil }
        }
    }

    func getCompleteRows() -> [Int] {
        return grid
            .enumerated()
            .filter { (i, row) in
                !row.contains { cell in cell == nil }
            }
            .map { (i, row) in i }
    }

    func spawn(_ tetromino: Tetromino, at coordinates: Coordinates) {
        for (vertical, horizontal) in coordinates {
            grid[vertical][horizontal] = tetromino
        }
    }

    func translate(_ tetromino: Tetromino, at coordinates: Coordinates, verticallyBy: Int = 0, horizontallyBy: Int = 0) {
        let to = coordinates.map { (v, h) in
            (v + verticallyBy, h + horizontallyBy)
        }

        move(tetromino, at: coordinates, to: to)
    }

    func move(_ tetromino: Tetromino, at: Coordinates, to: Coordinates) {
        at.forEach { (v, h) in
            grid[v][h] = nil
        }

        to.forEach { (v, h) in
            grid[v][h] = tetromino
        }
    }

    func clearRows(_ rows: [Int]) {
        rows.forEach { i in
            grid.remove(at: i)
            grid.insert([Tetromino?](repeating: nil, count: width), at: 0)
        }
    }

}