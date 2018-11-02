import Foundation

public class Catalog {
    var drivers = [Driver]()
    var positions = [Position]()
    
    public init() { }
    
    public var tractors:[Tractor] {
        return drivers.compactMap{ driver in
            guard let position = positions.first(where:{ $0.driver_id == driver.id }) else { return nil }
            var tractor = Tractor()
            tractor.driver = driver.name
            tractor.latitude = position.latitude
            tractor.longitude = position.longitude
            return tractor
        }
    }
}
