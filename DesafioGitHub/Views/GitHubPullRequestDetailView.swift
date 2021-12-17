import Foundation
import SwiftUI

struct GitHubPullRequestDetailView: View {
    @ObservedObject var model: WebViewModel

    var body: some View {
        WebView(webView: model.webView)
            .navigationTitle(model.webView.title ?? "")
    }

    init(_ pullRequest: PullRequestModel) {
        model = WebViewModel(url: pullRequest.htmlUrl)
    }
}
