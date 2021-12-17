import SwiftUI
import Kingfisher

struct GitHubRepoNavigationView: View {
    @State var searchText = ""
    @ObservedObject var repositories = RepositoryListViewModel()

    var body: some View {
        NavigationView {
            GitHubRepoListView(repositories: repositories).toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    SortDirectionButton(repositories: repositories)
                    SortOptionsDialogView(repositories: repositories)
                }
            }
        }
        .navigationViewStyle(.stack)
        .searchable(text: $searchText)
    }
}

private struct SortDirectionButton: View {
    @ObservedObject var repositories: RepositoryListViewModel

    var body: some View {
        Button {
            repositories.ordering.reverse()
            repositories.reloadData()
        } label: {
            Image(systemName: {
                switch repositories.ordering {
                case .ascending: return "chevron.up"
                case .descending: return "chevron.down"
                }
            }())
        }
    }
}

private struct SortOptionsDialogView: View {
    @State private var showingSortOptions = false

    var repositories: RepositoryListViewModel

    var body: some View {
        Button("Sort") {
            showingSortOptions = true
        }.confirmationDialog(
            "Change sorting",
            isPresented: $showingSortOptions
        ) {
            ForEach(
                RepositorySortMethod.allCases, id: \.self
            ) { sortOption in
                SortOptionButtonView(
                    repositories: repositories,
                    currentlySelected: repositories.sortMethod,
                    sortMethod: sortOption
                )
            }

            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select desired sorting method")
        }
    }
}

private struct SortOptionButtonView: View {
    var repositories: RepositoryListViewModel

    var currentlySelected: RepositorySortMethod
    var sortMethod: RepositorySortMethod

    var body: some View {
        let isCurrent = currentlySelected == sortMethod
        let currentLabel = isCurrent ? " (current)" : ""

        Button(sortMethod.queryParam + currentLabel) {
            if !isCurrent {
                repositories.sortMethod = sortMethod
                repositories.reloadData()
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
