import Foundation

class Requester:RequesterProtocol {
    private weak var taskDrivers:URLSessionDataTask?
    private weak var taskPositions:URLSessionDataTask?
    private let session = URLSession(configuration:.ephemeral)
    private let drivers:URLRequest
    private let positions:URLRequest
    private static let timeout = 9.0
    private static let drivers = "https://coding-challenge-assets.s3.eu-central-1.amazonaws.com/drivers.json"
    private static let positions = "https://coding-challenge-assets.s3.eu-central-1.amazonaws.com/positions.json"
    
    init() {
        var drivers = URLRequest(url:URL(string:Requester.drivers)!, cachePolicy:
            .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:Requester.timeout)
        drivers.allowsCellularAccess = true
        
        var positions = URLRequest(url:URL(string:Requester.positions)!, cachePolicy:
            .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:Requester.timeout)
        positions.allowsCellularAccess = true
        
        self.drivers = drivers
        self.positions = positions
    }
    
    func drivers(completion:@escaping(([Driver]) -> Void)) {
        taskDrivers?.cancel()
        taskDrivers = session.dataTask(with:drivers) { [weak self] (data, response, error) in
            guard
                let data = self?.validate(data:data, response:response, error:error),
                let drivers = try? JSONDecoder().decode([Driver].self, from:data)
            else { return }
            completion(drivers)
        }
        taskDrivers?.resume()
    }
    
    func positions(completion:@escaping(([Position]) -> Void)) {
        taskPositions?.cancel()
        taskPositions = session.dataTask(with:positions) { [weak self] (data, response, error) in
            guard
                let data = self?.validate(data:data, response:response, error:error),
                let positions = try? JSONDecoder().decode([Position].self, from:data)
            else { return }
            completion(positions)
        }
        taskPositions?.resume()
    }
    
    private func validate(data:Data?, response:URLResponse?, error:Error?) -> Data? {
        guard
            error == nil,
            (response as? HTTPURLResponse)?.statusCode == 200,
            let data = data,
            !data.isEmpty
        else { return nil }
        return data
    }
}
