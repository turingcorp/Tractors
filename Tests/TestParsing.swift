import XCTest
@testable import Tractors

class TestParsing:XCTestCase {
    private let drivers = "[{\"id\": \"3f996204-f332-4f7a-b43e-6820944e11a9\", \"name\": \"Amelie\", \"active\": true}]"
    
    func testParsingDrivers() {
        let list = try! JSONDecoder().decode([Driver].self, from:drivers.data(using:.utf8)!)
        XCTAssertEqual("3f996204-f332-4f7a-b43e-6820944e11a9", list.first!.id)
        XCTAssertEqual("Amelie", list.first!.name)
        XCTAssertEqual(true, list.first!.active)
    }
}
