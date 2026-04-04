import SwiftUI
import WebKit

enum NavigationAction {
    case none, goBack, goForward, reload
}

struct WebView: UIViewRepresentable {
    @Binding var url: URL?
    @Binding var currentURL: String
    @Binding var currentTitle: String
    @Binding var estimatedProgress: Double
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var navigationAction: NavigationAction

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.observe(webView: webView)
        if let url = url {
            context.coordinator.lastRequestedURL = url
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url, url != context.coordinator.lastRequestedURL {
            context.coordinator.lastRequestedURL = url
            webView.load(URLRequest(url: url))
        }

        switch navigationAction {
        case .goBack:
            webView.goBack()
            DispatchQueue.main.async { navigationAction = .none }
        case .goForward:
            webView.goForward()
            DispatchQueue.main.async { navigationAction = .none }
        case .reload:
            webView.reload()
            DispatchQueue.main.async { navigationAction = .none }
        case .none:
            break
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var lastRequestedURL: URL?
        private var observations: [NSKeyValueObservation] = []

        init(_ parent: WebView) {
            self.parent = parent
        }

        func observe(webView: WKWebView) {
            observations = [
                webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                    DispatchQueue.main.async {
                        self?.parent.estimatedProgress = webView.estimatedProgress
                    }
                },
                webView.observe(\.isLoading) { [weak self] webView, _ in
                    DispatchQueue.main.async {
                        self?.parent.isLoading = webView.isLoading
                    }
                },
                webView.observe(\.canGoBack) { [weak self] webView, _ in
                    DispatchQueue.main.async {
                        self?.parent.canGoBack = webView.canGoBack
                    }
                },
                webView.observe(\.canGoForward) { [weak self] webView, _ in
                    DispatchQueue.main.async {
                        self?.parent.canGoForward = webView.canGoForward
                    }
                }
            ]
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.currentURL = webView.url?.absoluteString ?? ""
                self?.parent.currentTitle = webView.title ?? ""
            }
        }
    }
}
