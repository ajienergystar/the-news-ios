//
//  ArticlesContract.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
import UIKit

protocol ArticlesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showArticles(_ articles: [Article])
    func showEmptyState()
    func showError(_ message: String)
    func showLoadMoreIndicator()
    func hideLoadMoreIndicator()
}

protocol ArticlesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectArticle(_ article: Article)
    func didReachEndOfList()
    func didTapRetry()
}

protocol ArticlesInteractorProtocol: AnyObject {
    func fetchArticles(refresh: Bool)
    func searchArticles(query: String)
    func loadMoreArticles()
}

protocol ArticlesInteractorOutputProtocol: AnyObject {
    func didStartLoading(refresh: Bool)
    func didFinishLoading()
    func didFetchArticles(_ articles: [Article], refresh: Bool, hasMore: Bool)
    func didFail(with error: Error)
}

protocol ArticlesRouterProtocol: AnyObject {
    static func createModule(sourceID: String, container: DIContainer) -> UIViewController
    func navigateToArticleDetail(url: URL, title: String)
}
