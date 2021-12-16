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

    static let maxItemsPerPage = 100 // API limitation

    init() { }

    func find(
        dg dispatchGroup: DispatchGroup,
        search: String = "language:Swift",
        sortBy: RepositorySortMethod = .stars,
        order: SortDirection = .descending,
        page: Int = 1,
        itemsPerPage: Int = maxItemsPerPage,
        onComplete: @escaping ([RepositoryModel]) -> Void
    ) {
        AF.request(
            Self.baseUrl,
            parameters: [
                "q": search,
                "sort": sortBy.queryParam,
                "order": order.queryParam,
                "per_page": itemsPerPage,
                "page": page
            ]
        ) { request in
            request.addValue(
                "application/vnd.github.v3+json",
                forHTTPHeaderField: "Accept"
            )
        }.responseDecodable(
            of: GitHubRepositoryQueryResponse.self,
            decoder: Self.decoder
        ) { response in
            defer { dispatchGroup.leave() }
            guard let results = try? response.result.get() else { return }

            // TODO: Verificar se esta na ultima pagina
            // print(response.response?.headers.value(for: "Link"))

            onComplete(results.items)
        }
    }
}

private struct GitHubRepositoryQueryResponse: Decodable {
    let items: [RepositoryModel]
}
