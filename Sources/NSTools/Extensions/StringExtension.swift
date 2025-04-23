public extension String {
    public func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
