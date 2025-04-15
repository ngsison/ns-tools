import Foundation

@propertyWrapper
public struct UserDefaultsObject<T> where T: Codable {
    
    private let key: String
    private let storage: UserDefaults = .standard
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public let defaultValue: T
    public var wrappedValue: T {
        get {
            guard let data = storage.data(forKey: key),
                  let object = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return object
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                if let data = try? JSONEncoder().encode(newValue) {
                    storage.set(data, forKey: key)
                } else {
                    storage.removeObject(forKey: key)
                }
            }
        }
    }
}
