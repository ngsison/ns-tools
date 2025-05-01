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

public extension APIResult {
    static func mockSuccess() -> APIResult {
        let url = URL(string: "https://mock.api")!
        let req = URLRequest(url: url)
        let res = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return APIResult(request: req, response: res)
    }
    
    static func mockFailure(statusCode: Int = 500, body: String? = nil) -> APIResult {
        let url = URL(string: "https://mock.api")!
        let req = URLRequest(url: url)
        let res = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let data = body?.data(using: .utf8)
        return APIResult(request: req, response: res, data: data)
    }
}
