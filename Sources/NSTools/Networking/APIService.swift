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
        return try await performRequest(api: api)
    }
    
    public func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T {
        let result = try await performRequest(api: api)
        
        guard let data = result.data else {
            print("[NSTools] Error: No Data")
            throw APIError.noData
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(responseType, from: data)
            print("[NSTools] Decoding success for type: \(responseType)")
            return decodedObject
        } catch {
            print("[NSTools] Decoding failed for type: \(responseType), error: \(error)")
            throw APIError.decodableMapping(error)
        }
    }
    
    private func performRequest(api: API) async throws -> APIResult {
        let request = try api.buildRequest()
        
        print("[NSTools] API Request: \(request)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            print("[NSTools] Error: No Response")
            throw APIError.noResponse
        }
        
        print("[NSTools] API Response: \(response)")
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("[NSTools] API Response Data:\n\(prettyString)")
        }
        
        let result = APIResult(request: request, response: response, data: data)
        
        switch response.statusCode {
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
