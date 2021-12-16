import Foundation

enum RepositorySortBy: CaseIterable {
    case stars
    case forks
    case helpWantedIssues
    case updated
}

extension RepositorySortBy: Queryable {
    var queryParam: String {
        switch self {
        case .stars: return "stars"
        case .forks: return "forks"
        case .helpWantedIssues: return "help-wanted-issues"
        case .updated: return "updated"
        }
    }
}
