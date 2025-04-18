import Combine

public func sync<T: Equatable>(source: inout Published<T>.Publisher,
                               destination: inout Published<T>.Publisher) {
    source
        .removeDuplicates()
        .assign(to: &destination)
    
    destination
        .removeDuplicates()
        .assign(to: &source)
}
