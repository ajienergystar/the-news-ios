//
//  ArticleDetailViewController.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController {

    var presenter: ArticleDetailPresenterProtocol?
    var screenTitle: String?

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()

    private let loadingView = LoadingView()
    private var errorStateView: ErrorStateView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = screenTitle
        view.backgroundColor = .systemBackground
        setupLayout()
        presenter?.viewDidLoad()
    }

    private func setupLayout() {
        view.addSubview(webView.prepareForAutoLayout())
        webView.pinToSuperviewSafeArea()
    }

    private func clearOverlayViews() {
        loadingView.removeFromSuperview()
        errorStateView?.removeFromSuperview()
        errorStateView = nil
    }
}

extension ArticleDetailViewController: ArticleDetailViewProtocol {
    func loadURL(_ url: URL) {
        clearOverlayViews()
        webView.load(URLRequest(url: url))
    }

    func showLoading() {
        clearOverlayViews()
        view.addSubview(loadingView.prepareForAutoLayout())
        loadingView.pinToSuperviewSafeArea()
        webView.isHidden = true
    }

    func hideLoading() {
        loadingView.removeFromSuperview()
        webView.isHidden = false
    }

    func showError(_ message: String) {
        clearOverlayViews()
        let errorView = ErrorStateView(message: message)
        errorView.onRetry = { [weak self] in
            self?.presenter?.didTapRetry()
        }
        errorStateView = errorView
        view.addSubview(errorView.prepareForAutoLayout())
        errorView.pinToSuperviewSafeArea()
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        showError(error.localizedDescription)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        hideLoading()
        showError(error.localizedDescription)
    }
}
