import XCTest
@testable import Tractors

class TestParsing:XCTestCase {
    private let drivers = "[{\"id\": \"3f996204-f332-4f7a-b43e-6820944e11a9\", \"name\": \"Amelie\", \"active\": true}]"
    private let positions = "[{\"driver_id\": \"00732049-4118-4399-8885-4d188885da3e\", \"latitude\": 52.3522680067014, \"longitude\": 0.11024982528771297e2, \"timestamp\": \"2018-06-20T04:58:12.999Z\"}]"
    
    func testParsingDrivers() {
        let list = try! JSONDecoder().decode([Driver].self, from:drivers.data(using:.utf8)!)
        XCTAssertEqual("3f996204-f332-4f7a-b43e-6820944e11a9", list.first!.id)
        XCTAssertEqual("Amelie", list.first!.name)
        XCTAssertEqual(true, list.first!.active)
    }
    
    func testParsingPosition() {
        let list = try! JSONDecoder().decode([Position].self, from:positions.data(using:.utf8)!)
        XCTAssertEqual("00732049-4118-4399-8885-4d188885da3e", list.first!.driver_id)
        XCTAssertEqual(52.3522680067014, list.first!.latitude)
        XCTAssertEqual(0.11024982528771297e2, list.first!.longitude)
        XCTAssertEqual("2018-06-20T04:58:12.999Z", list.first!.timestamp)
    }
}
