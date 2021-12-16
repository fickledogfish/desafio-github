import Alamofire
import Foundation

struct GitHubPullRequestListService {
    static let decoder: DataDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    static let baseUrl = "https://api.github.com/repos/%@/pulls"

    static let maxItemsPerPage = 100 // API limitation

    init() { }

    func list(
        dg dispatchGroup: DispatchGroup,
        for repositoryFullName: String,
        state: PullRequestState = .open,
        sort: PullRequestSortMethod = .created,
        direction: SortDirection = .ascending,
        page: Int = 1,
        itemsPerPage: Int = maxItemsPerPage,
        onComplete: @escaping ([PullRequestModel]) -> Void
    ) {
        let url = String(format: Self.baseUrl, repositoryFullName)

        AF.request(
            url,
            parameters: [
                "state": state.queryParam,
                "sort": sort.queryParam,
                "direction": direction.queryParam,
                "per_page": itemsPerPage,
                "page": page
            ]
        ) { request in
            request.addValue(
                "application/vnd.github.v3+json",
                forHTTPHeaderField: "Accept"
            )
        }.responseDecodable(
            of: [PullRequestModel].self,
            decoder: Self.decoder
        ) { response in
            defer { dispatchGroup.leave() }
            guard let pullRequests = try? response.result.get() else { return }

            // TODO: Verificar se esta na ultima pagina

            onComplete(pullRequests)
        }
    }
}
