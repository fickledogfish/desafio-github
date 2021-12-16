import Foundation

class RepositoryPullRequestsViewModel: ObservableObject {
    @Published var repositoryFullName: String

    lazy var pullRequests: [PullRequestModel] = {
        print("here")
        return []
    }()

    init(for repository: RepositoryModel) {
        repositoryFullName = repository.fullName
    }
}
