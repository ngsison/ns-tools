public enum APIBody {
    case encodable(Encodable)
    case dictionary([String: Any])
}
