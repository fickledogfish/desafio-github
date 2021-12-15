import Foundation

enum SortBy {
    case stars
}

extension SortBy: Queryable {
    var queryParam: String {
        switch self {
        case .stars: return "stars"
        }
    }
}
