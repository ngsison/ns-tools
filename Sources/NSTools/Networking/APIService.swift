import Foundation

public protocol APIService {
    func refreshToken() async throws
    func request(api: API) async throws -> APIResult
    func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T
}

extension APIService {
    public func refreshToken() async throws {
        throw APIError.notImplemented
    }
    
    public func request(api: API) async throws -> APIResult {
        print("Starting request: \(api)")
        return try await performRequest(api: api)
    }
    
    public func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T {
        print("Starting request with expected response type: \(responseType)")
        let result = try await performRequest(api: api)

        guard let data = result.data else {
            throw APIError.noResponse
        }

        do {
            let decodedObject = try JSONDecoder().decode(responseType, from: data)
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
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("JSON Response:\n\(prettyString)")
        }
        
        switch result.response.statusCode {
        case 200...299:
            return result
        case 401:
            do {
                try await refreshToken()
                return try await performRequest(api: api)
            } catch {
                throw APIError.unauthorized(result)
            }
        default:
            throw APIError.statusCode(result)
        }
    }
}
