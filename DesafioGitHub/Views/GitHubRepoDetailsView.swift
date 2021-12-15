import SwiftUI

struct GitHubRepoDetailsView: View {
    var repository: Repository

    var body: some View {
        Text("hi there")
    }

    init(_ repository: Repository) {
        self.repository = repository
    }
}
