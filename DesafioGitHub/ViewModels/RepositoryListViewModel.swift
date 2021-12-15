import Foundation

class RepositoryListViewModel: ObservableObject {
    private static let lookaheadMinimum = 10

    @Published private(set) var isLoading = false
    @Published private(set) var loadedRepositories = [Repository]()

    private var canLoadMore = true
    private var currentPage = 0
    private let loadingDispatchGroup = DispatchGroup()

    private let searchServiceProvider: GitHubRepositorySearchService?

    init() {
        searchServiceProvider = GitHubRepositorySearchService()
        loadedRepositories = []

        loadNextPage()
    }

    // Para ser usado com previews
    #if DEBUG
    init(repositories: [Repository]) {
        searchServiceProvider = nil
        loadedRepositories = repositories
        isLoading = true
    }
    #endif

    func loadMoreIfNeeded(current: Repository) {
        let currentCount = loadedRepositories.count
        let currentIndex = loadedRepositories.firstIndex { current.id == $0.id } ?? 0
        let isNearLookahead = currentIndex >= currentCount - Self.lookaheadMinimum

        if canLoadMore && !isLoading && isNearLookahead {
            loadNextPage()
        }
    }

    private func loadNextPage() {
        guard let provider = searchServiceProvider else { return }

        isLoading = true
        currentPage += 1
        loadingDispatchGroup.enter()

        provider.find(
            dg: loadingDispatchGroup,
            page: currentPage
        ) { [weak self] repos in
            guard let this = self else { return }

            this.loadedRepositories.append(contentsOf: repos)
        }

        loadingDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let this = self else { return }
            this.isLoading = false
        }
    }
}
