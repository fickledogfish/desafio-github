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

    private init() { }

    static func find(
        search: String = "language:Swift",
        sortBy: SortBy = .stars,
        page: Int = 1,
        itemsPerPage: Int = maxItemsPerPage,
        onComplete: ([Repository]) -> Void
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
            decoder: decoder
        ) { response in
            debugPrint(response)
        }
    }
}

private struct GitHubRepositoryQueryResponse: Decodable {
    let items: [Repository]
}
