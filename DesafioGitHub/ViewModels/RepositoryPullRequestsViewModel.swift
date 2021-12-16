import Foundation

class RepositoryPullRequestsViewModel: ObservableObject {
    private static let lookaheadMinimum = 10

    @Published private(set) var isLoading = false
    @Published private(set) var repositoryFullName: String

    private var canLoadMore = true
    private var currentPage = 0
    private let loadingDispatchGroup = DispatchGroup()

    private let pullRequestServiceProvider: GitHubPullRequestListService?

    lazy var pullRequests: [PullRequestModel] = {
        loadNextPage()
        return []
    }()

    init(for repository: RepositoryModel) {
        repositoryFullName = repository.fullName
        pullRequestServiceProvider = GitHubPullRequestListService()
    }

    func loadMoreIfNeeded(current: PullRequestModel) {
        let currCount = pullRequests.count
        let currIndex = pullRequests.firstIndex { current.id == $0.id } ?? 0
        let isNearLookahead = currIndex >= currCount - Self.lookaheadMinimum

        if canLoadMore && !isLoading && isNearLookahead {
            loadNextPage()
        }
    }

    private func loadNextPage() {
        guard let provider = pullRequestServiceProvider else { return }

        isLoading = true
        currentPage += 1
        loadingDispatchGroup.enter()

        provider.list(
            dg: loadingDispatchGroup,
            for: repositoryFullName,
            page: currentPage
        ) { [weak self] pullRequests in
            guard let this = self else { return }

            this.pullRequests.append(contentsOf: pullRequests)
        }

        loadingDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let this = self else { return }
            this.isLoading = false
        }
    }}
