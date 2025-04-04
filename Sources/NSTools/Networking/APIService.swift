import Foundation

public protocol APIService {
    func request(api: API) async throws -> APIResult
    func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T
    func streamRequest(api: API) async throws -> AsyncThrowingStream<UInt8, Error>
}

extension APIService {
    public func request(api: API) async throws -> APIResult {
        print("Starting request: \(api)")
        return try await performRequest(api: api)
    }
    
    public func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T {
        print("Starting request with expected response type: \(responseType)")
        let result = try await performRequest(api: api)
        do {
            let decodedObject = try JSONDecoder().decode(responseType, from: result.data!)
            print("Successfully decoded response of type: \(responseType)")
            print(decodedObject)
            return decodedObject
        } catch {
            print("Error decoding response: \(error)")
            throw APIError.decodableMapping(error)
        }
    }
    
    private func performRequest(api: API) async throws -> APIResult {
        print("Building request for API: \(api)")
        let request = try api.buildRequest()
        
        print("Sending request: \(request)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            print("No response received from server")
            throw APIError.noResponse
        }
        
        let result = APIResult(request: request, response: response, data: data)
        print("Received response with status code: \(result)")
        
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
        print("Starting stream request for API: \(api)")
        let request = try api.buildRequest()
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            print("No response received from server during streaming")
            throw APIError.noResponse
        }
        
        let result = APIResult(request: request, response: response)
        print("Received streaming response with status code: \(response.statusCode)")
        
        switch result.response.statusCode {
        case 200...299:
            print("Stream started successfully")
            return AsyncThrowingStream<UInt8, Error> { continuation in
                Task {
                    do {
                        for try await byte in bytes {
                            continuation.yield(byte)
                        }
                        print("Stream completed successfully")
                        continuation.finish()
                    } catch {
                        print("Error during streaming: \(error)")
                        continuation.finish(throwing: error)
                    }
                }
            }
        case 401:
            print("Unauthorized stream request, status code 401")
            throw APIError.unauthorized(result)
        default:
            print("Stream request failed with status code: \(response.statusCode)")
            throw APIError.statusCode(result)
        }
    }
}
