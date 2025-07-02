public typealias Coordinates = [(vertical: Int, horizontal: Int)]

extension Coordinates {

    func contains(vertical: Int, horizontal: Int) -> Bool {
        self.contains { (v, h) in v == vertical && h == horizontal }
    }

}
