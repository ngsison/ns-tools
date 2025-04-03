enum APIError: Error {
    case invalidURL
    case noResponse
    case encodableMapping(_ error: Error)
    case decodableMapping(_ error: Error)
    case underlying(_ error: Error)
    case unauthorized(_ result: APIResult)
    case statusCode(_ result: APIResult)
    case unknown(_ result: APIResult)
}
