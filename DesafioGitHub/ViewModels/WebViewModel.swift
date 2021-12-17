import Foundation
import WebKit

class WebViewModel: ObservableObject {
    @Published var webView: WKWebView
    let url: String

    init(url: String) {
        webView = WKWebView(frame: .zero)
        self.url = url

        loadUrl()
    }

    func loadUrl() {
        guard let url = URL(string: url) else { return }

        webView.load(URLRequest(url: url))
    }
}
