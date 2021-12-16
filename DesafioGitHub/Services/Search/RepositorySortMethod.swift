import Foundation

enum RepositorySortMethod: CaseIterable {
    case stars
    case forks
    case helpWantedIssues
    case updated
}

extension RepositorySortMethod: Queryable {
    var queryParam: String {
        switch self {
        case .stars: return "stars"
        case .forks: return "forks"
        case .helpWantedIssues: return "help-wanted-issues"
        case .updated: return "updated"
        }
    }
}
