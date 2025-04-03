import Foundation

public protocol API {
    var baseURL: String { get }
    var path: String { get }
    var method: APIMethod { get }
    var headers: [String: String] { get }
    var body: APIBody { get }
    var urlParameters: [String: String?] { get }
}

extension API {
    public func buildRequest() throws -> URLRequest {
        let url = try buildUrl()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = buildHeaders()
        request.httpBody = try buildBody()
        
        return request
    }
    
    private func buildUrl() throws -> URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = urlParameters.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
    
    private func buildHeaders() -> [String: String] {
        var allHeaders: [String: String] = ["Content-Type": "application/json"]
        headers.forEach { allHeaders[$0.key] = $0.value }
        return allHeaders
    }
    
    private func buildBody() throws -> Data? {
        guard method == .POST else { return nil }
        
        switch body {
        case .encodable(let encodable):
            return try JSONEncoder().encode(encodable)
        case .dictionary(let dictionary):
            return try JSONSerialization.data(withJSONObject: dictionary)
        case .none:
            return nil
        }
    }
}
