import XCTest
@testable import Tractors

class TestMerging:XCTestCase {
    private var catalog:Catalog!

    override func setUp() {
        catalog = Catalog()
    }
    
    func testGetTractorInfo() {
        catalog.drivers = [Driver(id:"a", name:"John", active:true)]
        catalog.positions = [Position(driver_id:"a", latitude:1, longitude:2, timestamp:"0")]
        XCTAssertEqual("John", catalog.tractors.first!.driver)
        XCTAssertEqual(1, catalog.tractors.first!.latitude)
        XCTAssertEqual(2, catalog.tractors.first!.longitude)
    }
}
