import Foundation

class RepositoryListViewModel: ObservableObject {
    private static let lookaheadMinimum = 5

    @Published private(set) var isLoading = false
    @Published private(set) var loaded = [Repository]()

    private var canLoadMore = true
    private let loadingDispatchGroup = DispatchGroup()

    init() {
        loadMore()
    }

    func loadMoreIfNeeded(current: Repository) {
        let currentCount = loaded.count
        let currentIndex = loaded.firstIndex { current.id == $0.id } ?? 0

        if canLoadMore && !isLoading &&
            currentIndex >= currentCount - Self.lookaheadMinimum {
            loadMore()
        }
    }

    private func loadMore() {
        GitHubRepositorySearchService.find { _ in
        }
    }
}
