import SwiftUI

struct GitHubRepoDetailsView: View {
    var repository: Repository

    var body: some View {
        VStack {
            Text("hi there")
        }.navigationTitle(repository.fullName)
    }

    init(_ repository: Repository) {
        self.repository = repository
    }
}

#if DEBUG
struct GitHubRepoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoDetailsView(Repository(
            id: 1,
            name: "Test",
            fullName: "t/Test",
            description: nil,
            owner: Owner(login: "t", avatarUrl: ""),
            watchers: 100,
            forks: 3,
            homepage: nil,
            createdAt: Date(),
            updatedAt: Date()
        ))
    }
}
#endif
