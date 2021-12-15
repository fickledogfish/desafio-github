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
