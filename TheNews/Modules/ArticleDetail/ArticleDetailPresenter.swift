//
//  ArticleDetailPresenter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class ArticleDetailPresenter: ArticleDetailPresenterProtocol {

    weak var view: ArticleDetailViewProtocol?
    var interactor: ArticleDetailInteractorProtocol?

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor?.prepareArticle(url: url)
    }

    func didTapRetry() {
        view?.showLoading()
        view?.loadURL(url)
    }
}

extension ArticleDetailPresenter: ArticleDetailInteractorOutputProtocol {
    func didPrepareArticle(url: URL) {
        view?.loadURL(url)
    }
}
