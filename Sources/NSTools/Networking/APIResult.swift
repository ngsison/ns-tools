import Foundation

public struct APIResult: Sendable {
    public var request: URLRequest
    public var response: HTTPURLResponse
    public var data: Data? = nil
    
    public init(request: URLRequest, response: HTTPURLResponse, data: Data? = nil) {
        self.request = request
        self.response = response
        self.data = data
    }
}
