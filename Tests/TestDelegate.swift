import XCTest
@testable import Tractors

class TestDelegate:XCTestCase {
    private var catalog:Catalog!
    private var delegate:MockDelegate!
    
    override func setUp() {
        catalog = Catalog()
        delegate = MockDelegate()
        catalog.delegate = delegate
    }
    
    func testNotifyOnTractorsUpdated() {
        let expect = expectation(description:String())
        delegate.onTractorsUpdated = { expect.fulfill() }
        catalog.update(drivers:[])
        waitForExpectations(timeout:1)
    }
}
