//
//  ArticlesPresenter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class ArticlesPresenter: ArticlesPresenterProtocol {

    weak var view: ArticlesViewProtocol?
    var interactor: ArticlesInteractorProtocol?
    var router: ArticlesRouterProtocol?

    private var hasMorePages = true
    private var searchWorkItem: DispatchWorkItem?

    func viewDidLoad() {
        interactor?.fetchArticles(refresh: true)
    }

    func didSearch(query: String) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.interactor?.searchArticles(query: query)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    func didCancelSearch() {
        searchWorkItem?.cancel()
        interactor?.fetchArticles(refresh: true)
    }

    func didSelectArticle(_ article: Article) {
        guard let url = article.articleURL else { return }
        router?.navigateToArticleDetail(url: url, title: article.title)
    }

    func didReachEndOfList() {
        guard hasMorePages else { return }
        view?.showLoadMoreIndicator()
        interactor?.loadMoreArticles()
    }

    func didTapRetry() {
        interactor?.fetchArticles(refresh: true)
    }
}

extension ArticlesPresenter: ArticlesInteractorOutputProtocol {
    func didStartLoading(refresh: Bool) {
        if refresh {
            view?.showLoading()
        }
    }

    func didFinishLoading() {
        view?.hideLoading()
        view?.hideLoadMoreIndicator()
    }

    func didFetchArticles(_ articles: [Article], refresh: Bool, hasMore: Bool) {
        hasMorePages = hasMore
        if articles.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showArticles(articles)
        }
    }

    func didFail(with error: Error) {
        view?.showError(error.localizedDescription)
    }
}
