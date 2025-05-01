import SwiftUI

@MainActor
public extension Binding where Value: Equatable {
    static func isNotNil<T>(_ optional: Binding<T?>) -> Binding<Bool> where Value == Bool {
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
