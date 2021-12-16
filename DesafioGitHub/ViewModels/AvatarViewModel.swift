import Foundation

final class AvatarViewModel: ObservableObject {
    let url: URL?

    init(url: String) {
        self.url = URL(string: url)
    }
}
