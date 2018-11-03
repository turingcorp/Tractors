import Foundation
@testable import Tractors

class MockRequester:RequesterProtocol {
    var drivers = [Driver]()
    var positions = [Position]()
    var onRequestDrivers:(() -> Void)?
    var onRequestPositions:(() -> Void)?
    
    func drivers(completion:@escaping(([Driver]) -> Void)) {
        onRequestDrivers?()
        completion(drivers)
    }
    
    func positions(completion:@escaping(([Position]) -> Void)) {
        onRequestPositions?()
        completion(positions)
    }
}
