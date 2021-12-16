import Foundation

enum RepositorySortBy {
    case stars
}

extension RepositorySortBy: Queryable {
    var queryParam: String {
        switch self {
        case .stars: return "stars"
        }
    }
}
