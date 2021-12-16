import Foundation

enum PullRequestState {
    case open, closed, all
}

extension PullRequestState: Queryable {
    var queryParam: String {
        switch self {
        case .open: return "open"
        case .closed: return "closed"
        case .all: return "all"
        }
    }
}
