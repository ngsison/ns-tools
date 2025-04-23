import Combine

public extension PassthroughSubject where Output == Void {
    public func send() {
        send(())
    }
}
