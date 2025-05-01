import Foundation

public extension TimeInterval {
    static func minutes(_ minutes: TimeInterval) -> TimeInterval {
        minutes * 60
    }
    
    static func hours(_ hours: TimeInterval) -> TimeInterval {
        hours * minutes(60)
    }
    
    static func days(_ days: TimeInterval) -> TimeInterval {
        days * hours(24)
    }
}
