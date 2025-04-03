import Foundation

public protocol APIService {
    func request(api: API) async throws -> APIResult
    func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T
    func streamRequest(api: API) async throws -> AsyncThrowingStream<UInt8, Error>
}

extension APIService {
    public func request(api: API) async throws -> APIResult {
        return try await performRequest(api: api)
    }
    
    public func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T {
        let result = try await performRequest(api: api)
        do {
            let decodedObject = try JSONDecoder().decode(responseType, from: result.data!)
            return decodedObject
        } catch {
            throw APIError.decodableMapping(error)
        }
    }
    
    private func performRequest(api: API) async throws -> APIResult {
        let request = try api.buildRequest()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw APIError.noResponse }
        let result = APIResult(request: request, response: response, data: data)
        
        switch result.response.statusCode {
        case 200...299:
            return result
        case 401:
            throw APIError.unauthorized(result)
        default:
            throw APIError.statusCode(result)
        }
    }
}

extension APIService {
    public func streamRequest(api: API) async throws -> AsyncThrowingStream<UInt8, Error> {
        let request = try api.buildRequest()
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        let result = APIResult(request: request, response: response)
        
        switch result.response.statusCode {
        case 200...299:
            return AsyncThrowingStream<UInt8, Error> { continuation in
                Task {
                    do {
                        for try await byte in bytes {
                            continuation.yield(byte)
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
        case 401:
            throw APIError.unauthorized(result)
        default:
            throw APIError.statusCode(result)
        }
    }
}
