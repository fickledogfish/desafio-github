import Foundation

enum SortDirection {
    case ascending, descending
}

extension SortDirection: Queryable {
    var queryParam: String {
        switch self {
        case .ascending: return "asc"
        case .descending: return "desc"
        }
    }
}
