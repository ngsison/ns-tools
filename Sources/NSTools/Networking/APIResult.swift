import Foundation

struct APIResult {
    var request: URLRequest
    var response: HTTPURLResponse
    var data: Data? = nil
}
