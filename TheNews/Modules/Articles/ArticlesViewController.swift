//
//  ArticlesViewController.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class ArticlesViewController: UIViewController {

    var presenter: ArticlesPresenterProtocol?

    private var articles: [Article] = []

    private let searchBar = SearchBarView()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.keyboardDismissMode = .onDrag
        table.backgroundColor = .secondarySystemBackground
        return table
    }()

    private let loadingView = LoadingView()
    private var emptyStateView: EmptyStateView?
    private var errorStateView: ErrorStateView?
    private let footerView = LoadingFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupTableView()
        searchBar.delegate = self
        presenter?.viewDidLoad()
    }

    private func setupLayout() {
        view.addSubviews(searchBar, tableView)
        searchBar.prepareForAutoLayout()
            .pinToSuperviewSafeArea(edges: [.top, .left, .right], padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        tableView.prepareForAutoLayout()
        tableView.placeBelow(searchBar, spacing: 8)
        [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].activate()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCardCell.self, forCellReuseIdentifier: ArticleCardCell.reuseIdentifier)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        footerView.isHidden = true
    }

    private func clearOverlayViews() {
        loadingView.removeFromSuperview()
        emptyStateView?.removeFromSuperview()
        errorStateView?.removeFromSuperview()
        emptyStateView = nil
        errorStateView = nil
    }
}

extension ArticlesViewController: ArticlesViewProtocol {
    func showLoading() {
        clearOverlayViews()
        view.addSubview(loadingView.prepareForAutoLayout())
        loadingView.pinToSuperviewSafeArea()
        tableView.isHidden = true
    }

    func hideLoading() {
        loadingView.removeFromSuperview()
        tableView.isHidden = false
    }

    func showArticles(_ articles: [Article]) {
        clearOverlayViews()
        self.articles = articles
        tableView.reloadData()
    }

    func showEmptyState() {
        clearOverlayViews()
        let empty = EmptyStateView(message: "No articles found")
        emptyStateView = empty
        view.addSubview(empty.prepareForAutoLayout())
        empty.pinToSuperviewSafeArea()
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

    func showLoadMoreIndicator() {
        footerView.isHidden = false
        footerView.startAnimating()
    }

    func hideLoadMoreIndicator() {
        footerView.stopAnimating()
        footerView.isHidden = true
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleCardCell.reuseIdentifier,
            for: indexPath
        ) as? ArticleCardCell else {
            return UITableViewCell()
        }
        cell.configure(article: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectArticle(articles[indexPath.row])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == articles.count - 1 else { return }
        presenter?.didReachEndOfList()
    }
}

extension ArticlesViewController: SearchBarViewDelegate {
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String) {
        presenter?.didSearch(query: text)
    }

    func searchBarDidCancel(_ searchBar: SearchBarView) {
        presenter?.didCancelSearch()
    }
}
