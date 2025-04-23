import SwiftUI

public struct NSList<ContentView: View, EmptyView: View>: View {
    private let isEmpty: Bool
    @ViewBuilder private let contentView: () -> ContentView
    @ViewBuilder private let emptyView: () -> EmptyView
    
    public init(isEmpty: Bool, contentView: @escaping () -> ContentView, emptyView: @escaping () -> EmptyView) {
        self.isEmpty = isEmpty
        self.contentView = contentView
        self.emptyView = emptyView
    }
    
    public var body: some View {
        GeometryReader { reader in
            List {
                if isEmpty {
                    Section {
                        VStack {
                            Spacer()
                            emptyView()
                            Spacer()
                        }
                        .frame(width: reader.size.width,
                               height: reader.size.height - reader.safeAreaInsets.top - reader.safeAreaInsets.bottom)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                } else {
                    contentView()
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .scrollContentBackground(.hidden)
        }
    }
}
