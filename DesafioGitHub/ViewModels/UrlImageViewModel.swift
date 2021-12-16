import UIKit
import Foundation

class UrlImageViewModel: ObservableObject {
    @Published var image: UIImage?

    let provider = GitHubAvatarService()

    init(from url: String) {
        guard !url.isEmpty else { return }

        loadImage(from: url)
    }

    private func loadImage(from url: String) {
        provider.getimage(from: url) { [weak self] image in
            guard let this = self else { return }
            this.image = image
        }
    }
}
