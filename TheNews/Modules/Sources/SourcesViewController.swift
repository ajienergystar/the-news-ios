//
//  SourcesViewController.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class SourcesViewController: UIViewController {

    var presenter: SourcesPresenterProtocol?
    var categoryTitle: String?

    private var sources: [NewsSource] = []

    private let searchBar = SearchBarView()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.keyboardDismissMode = .onDrag
        return table
    }()

    private let loadingView = LoadingView()
    private var emptyStateView: EmptyStateView?
    private var errorStateView: ErrorStateView?
    private let footerView = LoadingFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryTitle?.capitalized
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
        tableView.register(SourceCell.self, forCellReuseIdentifier: SourceCell.reuseIdentifier)
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

extension SourcesViewController: SourcesViewProtocol {
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

    func showSources(_ sources: [NewsSource]) {
        clearOverlayViews()
        self.sources = sources
        tableView.reloadData()
    }

    func showEmptyState() {
        clearOverlayViews()
        let empty = EmptyStateView(message: "No sources found")
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

extension SourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SourceCell.reuseIdentifier,
            for: indexPath
        ) as? SourceCell else {
            return UITableViewCell()
        }
        cell.configure(source: sources[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectSource(sources[indexPath.row])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == sources.count - 1 else { return }
        presenter?.didReachEndOfList()
    }
}

extension SourcesViewController: SearchBarViewDelegate {
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String) {
        presenter?.didSearch(query: text)
    }

    func searchBarDidCancel(_ searchBar: SearchBarView) {
        presenter?.didCancelSearch()
    }
}
