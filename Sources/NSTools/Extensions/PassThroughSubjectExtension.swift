import Combine

public extension PassthroughSubject where Output == Void {
    func send() {
        send(())
    }
}
