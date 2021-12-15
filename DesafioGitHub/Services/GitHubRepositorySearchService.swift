import Alamofire
import Foundation

struct GitHubRepositorySearchService {
    static let decoder: DataDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    static let baseUrl = "https://api.github.com/search/repositories"

    static let maxItemsPerPage = 30 // API limitation

    init() { }

    func find(
        dg dispatchGroup: DispatchGroup,
        search: String = "language:Swift",
        sortBy: SortBy = .stars,
        page: Int = 1,
        itemsPerPage: Int = maxItemsPerPage,
        onComplete: @escaping ([Repository]) -> Void
    ) {
        AF.request(
            Self.baseUrl,
            parameters: [
                "q": search,
                "sort": sortBy.queryParam,
                "per_page": itemsPerPage,
                "page": page
            ]
        ).responseDecodable(
            of: GitHubRepositoryQueryResponse.self,
            decoder: Self.decoder
        ) { response in
            defer { dispatchGroup.leave() }
            guard let results = try? response.result.get() else { return }

            onComplete(results.items)
        }
    }
}

private struct GitHubRepositoryQueryResponse: Decodable {
    let items: [Repository]
}
