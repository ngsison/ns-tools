import KeychainSwift

@propertyWrapper
public struct KeychainItem {
    
    private let key: String
    private let storage = KeychainSwift()
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        get {
            storage.get(key)
        }
        set {
            if let newValue, !newValue.isEmpty {
                storage.set(newValue, forKey: key)
            } else {
                storage.delete(key)
            }
        }
    }
}
