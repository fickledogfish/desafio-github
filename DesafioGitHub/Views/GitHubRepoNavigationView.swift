import SwiftUI

struct GitHubRepoNavigationView: View {
    @StateObject var repositories = RepositoryListViewModel()

    var body: some View {
        NavigationView {
            GitHubRepoListView(repositories: repositories)
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
            NavigationLink(destination: GitHubRepoDetailsView(repository)) {
                GitHubRepoCellView(repository: repository)
            }.onAppear {
                repositories.loadMoreIfNeeded(current: repository)
            }
        }
    }
}

private struct GitHubRepoCellView: View {
    var repository: Repository

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
    @ObservedObject var imageModel: UrlImageViewModel

    var body: some View {
        if let image = imageModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50)
        } else {
            Image(systemName: "trash")
        }
    }

    init(_ imageUrl: String) {
        imageModel = UrlImageViewModel(from: imageUrl)
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
        Repository(
            id: 1,
            name: "Test",
            fullName: "t/Test",
            description: "Yoggoth mnahn' vulgtm ebunma nafln'gha kn'a 'ai, " +
            "cgeb wgah'n shtunggliog bug hupadgh, goka ya fhtagn shugg " +
            "ebunma.",
            owner: Owner(login: "t", avatarUrl: ""),
            watchers: 100,
            forks: 3,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        ), Repository(
            id: 2,
            name: "Alamofire",
            fullName: "t/Alamofire",
            description: nil,
            owner: Owner(login: "testAccount", avatarUrl: ""),
            watchers: 143,
            forks: 13,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
}
#endif
