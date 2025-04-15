import Foundation

@propertyWrapper
public struct UserDefaultsItem<T> {
    
    private let key: String
    private let storage: UserDefaults = .standard
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public let defaultValue: T
    public var wrappedValue: T {
        get {
            let value = storage.value(forKey: key) as? T
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
}
