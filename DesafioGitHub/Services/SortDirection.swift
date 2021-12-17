import Foundation

enum SortDirection {
    case ascending
    case descending

    mutating func reverse() {
        if self == .ascending {
            self = .descending
        } else {
            self = .ascending
        }
    }
}

extension SortDirection: Queryable {
    var queryParam: String {
        switch self {
        case .ascending: return "asc"
        case .descending: return "desc"
        }
    }
}
