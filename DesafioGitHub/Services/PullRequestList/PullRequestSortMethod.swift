import Foundation

enum PullRequestSortMethod {
    case created, updated, popularity, longRunning
}

extension PullRequestSortMethod: Queryable {
    var queryParam: String {
        switch self {
        case .created: return "created"
        case .updated: return "updated"
        case .popularity: return "popularity"
        case .longRunning: return "long-running"
        }
    }
}
