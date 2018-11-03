import Foundation
import Tractors

class MockDelegate:Delegate {
    var onTractorsUpdated:(() -> Void)?
    
    func tractorsUpdated() {
        onTractorsUpdated?()
    }
}
