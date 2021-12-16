import SwiftUI
import Kingfisher

struct GitHubPullRequestsView: View {
    @ObservedObject var pullRequests: RepositoryPullRequestsViewModel

    var body: some View {
        PullRequestListView(pullRequests: pullRequests)
    }

    init(_ repository: RepositoryModel) {
        pullRequests = RepositoryPullRequestsViewModel(for: repository)
    }
}

private struct PullRequestListView: View {
    @StateObject var pullRequests: RepositoryPullRequestsViewModel

    var body: some View {
        List {
            ForEach(pullRequests.pullRequests) { pullRequest in
                NavigationLink(
                    destination: GitHubPullRequestDetailView(pullRequest)
                ) {
                    PullRequestCellView(pullRequest)
                }
            }
        }
        .navigationTitle(pullRequests.repositoryFullName)
        .listStyle(.grouped)
    }
}

private struct PullRequestCellView: View {
    var pullRequest: PullRequestModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                KFImage
                    .url(URL(string: pullRequest.user.avatarUrl))
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 25)

                Text(pullRequest.title)
                    .font(.title)
                    .lineLimit(1)
            }

            Spacer(minLength: 15)

            Text({ () -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                let userName = pullRequest.user.login
                let date = dateFormatter.string(from: pullRequest.createdAt)

                return "\(userName) @ \(date)"
            }())
                .font(.callout)
                .foregroundColor(.gray)

            Spacer(minLength: 15)

            Text(pullRequest.body)
                .font(.body)
                .lineLimit(5)
        }.onAppear {
            print(pullRequest.title)
        }
    }

    init(_ pullRequest: PullRequestModel) {
        self.pullRequest = pullRequest
    }
}

#if DEBUG
struct GitHubRepoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubPullRequestsView(RepositoryModel(
            id: 1,
            name: "Test",
            fullName: "t/Test",
            description: nil,
            owner: User(login: "t", avatarUrl: ""),
            watchers: 100,
            forks: 3,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        ))
    }
}
#endif
