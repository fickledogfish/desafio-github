import SwiftUI
import Kingfisher

struct GitHubRepoNavigationView: View {
    @State private var showingConfirmation = false

    @StateObject var repositories = RepositoryListViewModel()

    var body: some View {
        NavigationView {
            GitHubRepoListView(repositories: repositories)
        .toolbar {
            Button("Sort") {
                showingConfirmation = true
            }.confirmationDialog(
                "Change sorting",
                isPresented: $showingConfirmation
            ) {
                ForEach(
                    RepositorySortMethod.allCases, id: \.self
                ) { sortOption in
                    let isCurrentMethod = repositories.sortMethod == sortOption
                    let currentLabel = isCurrentMethod ? " (current)" : ""

                    Button(sortOption.queryParam + currentLabel) {
                        if !isCurrentMethod {
                            repositories.sortMethod = sortOption
                            repositories.reloadData()
                        }
                    }
                }

                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select desired sorting method")
            }
        }
        }
    }
}

private struct GitHubRepoListView: View {
    @StateObject var repositories: RepositoryListViewModel

    var body: some View {
        List {
            GitHubRepoListItemsView(repositories: repositories)

            if repositories.isLoading {
                GeometryReader { geoProxy in
                    ProgressView().position(
                        x: geoProxy.size.width / 2,
                        y: geoProxy.size.height / 2
                    )
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                .listRowSeparator(.hidden)
            }
        }
        .navigationTitle("GitHub")
        .listStyle(.grouped)
    }
}

private struct GitHubRepoListItemsView: View {
    @StateObject var repositories: RepositoryListViewModel

    var body: some View {
        ForEach(repositories.loadedRepositories) { repository in
            NavigationLink(destination: GitHubPullRequestsView(repository)) {
                GitHubRepoCellView(repository: repository)
            }.onAppear {
                repositories.loadMoreIfNeeded(current: repository)
            }
        }
    }
}

private struct GitHubRepoCellView: View {
    var repository: RepositoryModel

    var body: some View {
        HStack(spacing: 20) {
            VStack {
                GitHubRepoOwnerImageView(repository.owner.avatarUrl)

                Spacer()

                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "tuningfork")
                        Text("\(repository.forks)")
                    }

                    HStack {
                        Image(systemName: "star")
                        Text("\(repository.watchers)")
                    }
                }
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(repository.owner.login)
                        .font(.title3.italic())

                    Text(repository.name)
                        .font(.title2.bold())
                }

                Spacer()

                Text(repository.description ?? "No description provided")
                    .font(.body)
            }
        }
    }
}

private struct GitHubRepoOwnerImageView: View {
    @ObservedObject var avatar: AvatarViewModel

    var body: some View {
        KFImage
            .url(avatar.url)
            .placeholder { ProgressView() }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 50)
    }

    init(_ imageUrl: String) {
        avatar = AvatarViewModel(url: imageUrl)
    }
}

#if DEBUG
struct GitHubRepoListView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoNavigationView(
            repositories: RepositoryListViewModel(
                repositories: Self.repositoryListDebugData
            )
        )
    }

    static var repositoryListDebugData = [
        RepositoryModel(
            id: 1,
            name: "Test",
            fullName: "t/Test",
            description: "Yoggoth mnahn' vulgtm ebunma nafln'gha kn'a 'ai, " +
            "cgeb wgah'n shtunggliog bug hupadgh, goka ya fhtagn shugg " +
            "ebunma.",
            owner: User(login: "t", avatarUrl: ""),
            watchers: 100,
            forks: 3,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        ), RepositoryModel(
            id: 2,
            name: "Alamofire",
            fullName: "t/Alamofire",
            description: nil,
            owner: User(login: "testAccount", avatarUrl: ""),
            watchers: 143,
            forks: 13,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
}
#endif
