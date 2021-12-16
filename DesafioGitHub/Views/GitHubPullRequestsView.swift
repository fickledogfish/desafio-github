import SwiftUI

struct GitHubPullRequestsView: View {
    @ObservedObject var pullRequests: RepositoryPullRequestsViewModel

    var body: some View {
        VStack {
            ForEach(pullRequests.pullRequests) { pullRequest in
                Text("\(pullRequest.number)")
                Text("\(pullRequest.title)")
            }
        }.navigationTitle(pullRequests.repositoryFullName)
    }

    init(_ repository: RepositoryModel) {
        pullRequests = RepositoryPullRequestsViewModel(for: repository)
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
