import Foundation

public protocol APIService {
    func request(api: API) async throws -> APIResult
    func request<T: Decodable>(api: API, responseType: T.Type) async throws -> T
    func streamRequest(api: API) async throws -> AsyncThrowingStream<UInt8, Error>
}
