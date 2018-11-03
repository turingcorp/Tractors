import Foundation

protocol RequesterProtocol {
    func drivers(completion:@escaping(([Driver]) -> Void))
    func positions(completion:@escaping(([Position]) -> Void))
}
