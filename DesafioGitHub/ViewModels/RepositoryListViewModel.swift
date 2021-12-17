import Foundation

class RepositoryListViewModel: ObservableObject {
    private static let lookaheadMinimum = 10

    @Published private(set) var isLoading = false
    @Published private(set) var loadedRepositories = [RepositoryModel]()

    var sortMethod: RepositorySortMethod = .stars
    var ordering: SortDirection = .descending

    private var canLoadMore = true
    private var currentPage = 0
    private let loadingDispatchGroup = DispatchGroup()

    private var searchServiceProvider: GitHubRepositorySearchService?

    init() {
        searchServiceProvider = GitHubRepositorySearchService()

        reloadData()
    }

    // Para ser usado com previews
    #if DEBUG
    init(repositories: [RepositoryModel]) {
        searchServiceProvider = nil
        loadedRepositories = repositories
        isLoading = true
    }
    #endif

    func reloadData() {
        loadedRepositories = []
        currentPage = 0

        loadNextPage()
    }

    func loadMoreIfNeeded(current: RepositoryModel) {
        let currCount = loadedRepositories.count
        let currIndex = loadedRepositories.firstIndex { current.id == $0.id } ?? 0
        let isNearLookahead = currIndex >= currCount - Self.lookaheadMinimum

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
            sortBy: self.sortMethod,
            order: self.ordering,
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
