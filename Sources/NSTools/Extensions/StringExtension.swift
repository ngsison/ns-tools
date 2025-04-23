public extension String {
    mutating public func trim() {
        self = trimmed()
    }
    
    public func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
