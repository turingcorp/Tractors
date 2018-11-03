import Foundation

public class Catalog {
    public var tractors = [Tractor]()
    private var driversMap = [String:Driver]() { didSet { updateTractors() } }
    private var positionsMap = [String:Position]() { didSet { updateTractors() } }
    private let formatter = DateFormatter()
    
    public init() {
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier:"UTC")
    }
    
    func update(drivers:[Driver]) {
        var driversMap = self.driversMap
        drivers.forEach { driversMap[$0.id] = $0 }
        self.driversMap = driversMap
    }
    
    func update(positions:[Position]) {
        var positionsMap = self.positionsMap
        positions.forEach { position in
            if let oldPosition = positionsMap[position.driver_id] {
                positionsMap[position.driver_id] = mostRecent(positionA:position, positionB:oldPosition)
            } else {
                positionsMap[position.driver_id] = position
            }
        }
        self.positionsMap = positionsMap
    }
    
    private func updateTractors() {
        tractors = driversMap.compactMap{ id, driver in
            guard
                driver.active,
                let position = positionsMap[id]
            else { return nil }
            var tractor = Tractor()
            tractor.driver = driver.name
            tractor.latitude = position.latitude
            tractor.longitude = position.longitude
            return tractor
        }
    }
    
    private func mostRecent(positionA:Position, positionB:Position) -> Position {
        guard
            let dateA = formatter.date(from:positionA.timestamp),
            let dateB = formatter.date(from:positionB.timestamp),
            dateA > dateB
        else { return positionB }
        return positionA
    }
}
