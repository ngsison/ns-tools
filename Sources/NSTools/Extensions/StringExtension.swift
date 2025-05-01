public extension String {
    mutating func trim() {
        self = trimmed()
    }
    
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
