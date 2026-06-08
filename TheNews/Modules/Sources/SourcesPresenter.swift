//
//  SourcesPresenter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class SourcesPresenter: SourcesPresenterProtocol {

    weak var view: SourcesViewProtocol?
    var interactor: SourcesInteractorProtocol?
    var router: SourcesRouterProtocol?

    private let category: String

    init(category: String) {
        self.category = category
    }

    func viewDidLoad() {
        interactor?.fetchSources(category: category)
    }

    func didSearch(query: String) {
        interactor?.filterSources(query: query)
    }

    func didCancelSearch() {
        interactor?.filterSources(query: "")
    }

    func didSelectSource(_ source: NewsSource) {
        guard let sourceID = source.id else { return }
        router?.navigateToArticles(sourceID: sourceID)
    }

    func didReachEndOfList() {
        view?.showLoadMoreIndicator()
        interactor?.loadMoreSources()
    }

    func didTapRetry() {
        interactor?.fetchSources(category: category)
    }
}

extension SourcesPresenter: SourcesInteractorOutputProtocol {
    func didStartLoading() {
        view?.showLoading()
    }

    func didFinishLoading() {
        view?.hideLoading()
    }

    func didFetchSources(_ sources: [NewsSource]) {
        if sources.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showSources(sources)
        }
    }

    func didUpdateFilteredSources(_ sources: [NewsSource]) {
        view?.hideLoadMoreIndicator()
        if sources.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showSources(sources)
        }
    }

    func didLoadMoreSources(_ sources: [NewsSource]) {
        view?.hideLoadMoreIndicator()
        view?.showSources(sources)
    }

    func didFail(with error: Error) {
        view?.showError(error.localizedDescription)
    }
}
