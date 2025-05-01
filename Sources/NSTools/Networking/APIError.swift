import Foundation

public enum APIError: Error {
    case invalidURL
    case noResponse
    case noData
    case notImplemented
    case underlying(_ error: Error)
    case encodableMapping(_ error: Error)
    case decodableMapping(_ error: Error)
    case responseMapping(_ result: APIResult)
    case unauthorized(_ result: APIResult)
    case statusCode(_ result: APIResult)
    case unknown(_ result: APIResult)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No response"
        case .noData:
            return "No data"
        case .notImplemented:
            return "Not implemented"
        case .underlying:
            return "Underlying error"
        case .encodableMapping:
            return "Encoding failed"
        case .decodableMapping:
            return "Decoding failed"
        case .responseMapping:
            return "Invalid response format"
        case .unauthorized:
            return "Unauthorized"
        case .statusCode(let result):
            return "Request failed with status code \(result.response.statusCode)."
        case .unknown(let result):
            return "Unknown error: \(result)"
        }
    }
}
