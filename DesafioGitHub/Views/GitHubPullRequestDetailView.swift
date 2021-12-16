import Foundation
import SwiftUI

struct GitHubPullRequestDetailView: View {
    var model: WebViewModel

    var body: some View {
        WebView(webView: model.webView)
    }

    init(_ pullRequest: PullRequestModel) {
        model = WebViewModel(url: pullRequest.htmlUrl)
    }
}
