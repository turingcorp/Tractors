import XCTest
@testable import Tractors

class TestMerging:XCTestCase {
    private var catalog:Catalog!

    override func setUp() {
        catalog = Catalog()
    }
    
    func testGetTractorInfo() {
        catalog.update(drivers:[Driver(id:"a", name:"John", active:true)])
        catalog.update(positions:[Position(driver_id:"a", latitude:1, longitude:2, timestamp:String())])
        XCTAssertEqual("John", catalog.tractors.first!.driver)
        XCTAssertEqual(1, catalog.tractors.first!.latitude)
        XCTAssertEqual(2, catalog.tractors.first!.longitude)
    }
    
    func testIgnoreUnusedPositions() {
        catalog.update(drivers:[Driver(id:"a", name:"John", active:true)])
        catalog.update(positions:[Position(driver_id:"b", latitude:4, longitude:5, timestamp:String()),
                                  Position(driver_id:"a", latitude:1, longitude:2, timestamp:String()),
                                  Position(driver_id:"c", latitude:3, longitude:6, timestamp:String())])
        XCTAssertEqual(1, catalog.tractors.count)
        XCTAssertEqual("John", catalog.tractors.first!.driver)
        XCTAssertEqual(1, catalog.tractors.first!.latitude)
        XCTAssertEqual(2, catalog.tractors.first!.longitude)
    }
    
    func testIgnoreDriverNoPosition() {
        catalog.update(drivers:[Driver(id:"b", name:"Dan", active:true),
                                Driver(id:"a", name:"John", active:true),
                                Driver(id:"c", name:"Anne", active:true)])
        catalog.update(positions:[Position(driver_id:"a", latitude:1, longitude:2, timestamp:String())])
        XCTAssertEqual(1, catalog.tractors.count)
        XCTAssertEqual("John", catalog.tractors.first!.driver)
    }
    
    func testOnlyActiveDrivers() {
        catalog.update(drivers:[Driver(id:"b", name:"Dan", active:false),
                                Driver(id:"a", name:"Anne", active:true)])
        catalog.update(positions:[Position(driver_id:"a", latitude:0, longitude:0, timestamp:String()),
                                  Position(driver_id:"b", latitude:0, longitude:0, timestamp:String())])
        XCTAssertEqual(1, catalog.tractors.count)
        XCTAssertEqual("Anne", catalog.tractors.first!.driver)
    }
    
    func testOnlyLastPosition() {
        catalog.update(drivers:[Driver(id:"a", name:"Marie", active:true)])
        catalog.update(positions:
            [Position(driver_id:"a", latitude:3, longitude:4, timestamp:"2018-06-20T04:58:12.999Z"),
             Position(driver_id:"a", latitude:6, longitude:5, timestamp:"2018-06-20T04:58:13.999Z"),
             Position(driver_id:"a", latitude:7, longitude:8, timestamp:"2018-06-20T04:58:11.999Z")])
        XCTAssertEqual(6, catalog.tractors.first!.latitude)
        XCTAssertEqual(5, catalog.tractors.first!.longitude)
    }
}
