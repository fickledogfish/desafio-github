import Foundation

class RepositoryListViewModel: ObservableObject {
    private static let lookaheadMinimum = 5

    @Published private(set) var isLoading = false
    @Published private(set) var loadedRepositories = [Repository]()

    private var canLoadMore = true
    private let loadingDispatchGroup = DispatchGroup()

    private let searchServiceProvider: GitHubRepositorySearchService?

    init() {
        searchServiceProvider = GitHubRepositorySearchService()
        loadedRepositories = []

        loadMore()
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

        if canLoadMore && !isLoading &&
            currentIndex >= currentCount - Self.lookaheadMinimum {
            loadMore()
        }
    }

    private func loadMore() {
        guard let provider = searchServiceProvider else { return }

        isLoading = true
        loadingDispatchGroup.enter()

        provider.find(dg: loadingDispatchGroup) { [weak self] repos in
            guard let this = self else { return }

            this.loadedRepositories.append(contentsOf: repos)
        }

        loadingDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let this = self else { return }
            this.isLoading = false
        }
    }
}
