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
        ForEach(repositories.loaded) { repository in
            NavigationLink(destination: GitHubRepoDetailsView(repository)) {
                GitHubRepoCellView(repository: repository)
            }
        }
    }
}

private struct GitHubRepoCellView: View {
    var repository: Repository

    var body: some View {
        Text(repository.fullName)
    }
}

#if DEBUG
struct GitHubRepoListView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoNavigationView()
    }
}
#endif
