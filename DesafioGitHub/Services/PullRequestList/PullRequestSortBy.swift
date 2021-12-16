import Foundation

enum PullRequestSortBy {
    case created, updated, popularity, longRunning
}

extension PullRequestSortBy: Queryable {
    var queryParam: String {
        switch self {
        case .created: return "created"
        case .updated: return "updated"
        case .popularity: return "popularity"
        case .longRunning: return "long-running"
        }
    }
}
