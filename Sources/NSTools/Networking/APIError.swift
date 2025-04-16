public enum APIError: Error {
    case invalidURL
    case noResponse
    case notImplemented
    case underlying(_ error: Error)
    case encodableMapping(_ error: Error)
    case decodableMapping(_ error: Error)
    case responseMapping(_ result: APIResult)
    case unauthorized(_ result: APIResult)
    case statusCode(_ result: APIResult)
    case unknown(_ result: APIResult)
}
