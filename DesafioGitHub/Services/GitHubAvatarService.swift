import Foundation
import UIKit
import Alamofire

struct GitHubAvatarService {
    func getimage(
        from url: String,
        onComplete: @escaping (UIImage) -> Void
    ) {
        AF.request(url).response { response in
            guard let imageData = try? response.result.get() else { return }
            guard let loadedImage = UIImage(data: imageData) else { return }

            onComplete(loadedImage)
        }
    }
}
