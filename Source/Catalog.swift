import Foundation

public class Catalog {
    public weak var delegate:Delegate?
    public var interval = 30.0
    public private(set) var tractors = [Tractor]() { didSet { delegate?.tractorsUpdated() } }
    var requester:RequesterProtocol = Requester()
    private var driversMap = [String:Driver]() { didSet { updateTractors() } }
    private var positionsMap = [String:Position]() { didSet { updateTractors() } }
    private let formatter = DateFormatter()
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public init() {
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier:"UTC")
    }
    
    public func startRequests() {
        queue.async { [weak self] in self?.performRequest() }
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
    
    private func scheduleRequests() {
        queue.asyncAfter(deadline:.now() + interval) { [weak self] in self?.performRequest() }
    }
    
    private func performRequest() {
        requester.drivers { [weak self] drivers in
            self?.queue.async { [weak self] in
                self?.update(drivers:drivers)
            }
        }
        requester.positions { [weak self] positions in
            self?.queue.async { [weak self] in
                self?.update(positions:positions)
            }
        }
        scheduleRequests()
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
