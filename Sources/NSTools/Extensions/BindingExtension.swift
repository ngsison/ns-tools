import SwiftUI

public extension Binding where Value: Equatable {
    public static func isNotNil<T>(_ optional: Binding<T?>) -> Binding<Bool> where Value == Bool {
        Binding<Bool>(
            get: { optional.wrappedValue != nil },
            set: { newValue in
                if !newValue {
                    optional.wrappedValue = nil
                }
            }
        )
    }
}
