import XCTest
@testable import Tractors

class TestRequests:XCTestCase {
    private var catalog:Catalog!
    private var requester:MockRequester!
    
    override func setUp() {
        catalog = Catalog()
        requester = MockRequester()
        catalog.interval = 0.2
        requester.drivers = [Driver(id:"a", name:"Anna", active:true)]
        requester.positions = [Position(driver_id:"a", latitude:0, longitude:0, timestamp:String())]
        catalog.requester = requester
    }
    
    func testRequestDrivers() {
        let expect = expectation(description:String())
        requester.onRequestDrivers = {
            self.requester.onRequestDrivers = nil
            expect.fulfill()
        }
        catalog.startRequests()
        waitForExpectations(timeout:1)
    }
    
    func testRequestPositions() {
        let expect = expectation(description:String())
        requester.onRequestPositions = {
            self.requester.onRequestPositions = nil
            expect.fulfill()
        }
        catalog.startRequests()
        waitForExpectations(timeout:1)
    }
    
    func testSchedule() {
        let expect = expectation(description:String())
        var firstTime = true
        requester.onRequestDrivers = {
            if firstTime {
                firstTime = false
            } else {
                self.requester.onRequestDrivers = nil
                expect.fulfill()
            }
        }
        catalog.startRequests()
        waitForExpectations(timeout:1)
    }
    
    func testUpdateTractors() {
        let expect = expectation(description:String())
        var firstTime = true
        requester.onRequestDrivers = {
            if firstTime {
                firstTime = false
            } else {
                self.requester.onRequestDrivers = nil
                XCTAssertEqual("Anna", self.catalog.tractors.first!.driver)
                expect.fulfill()
            }
        }
        catalog.startRequests()
        waitForExpectations(timeout:1)
    }
}
