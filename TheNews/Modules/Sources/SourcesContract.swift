//
//  SourcesContract.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
import UIKit

protocol SourcesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showSources(_ sources: [NewsSource])
    func showEmptyState()
    func showError(_ message: String)
    func showLoadMoreIndicator()
    func hideLoadMoreIndicator()
}

protocol SourcesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectSource(_ source: NewsSource)
    func didReachEndOfList()
    func didTapRetry()
}

protocol SourcesInteractorProtocol: AnyObject {
    func fetchSources(category: String)
    func filterSources(query: String)
    func loadMoreSources()
}

protocol SourcesInteractorOutputProtocol: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFetchSources(_ sources: [NewsSource])
    func didUpdateFilteredSources(_ sources: [NewsSource])
    func didFail(with error: Error)
    func didLoadMoreSources(_ sources: [NewsSource])
}

protocol SourcesRouterProtocol: AnyObject {
    static func createModule(category: String) -> UIViewController
    func navigateToArticles(sourceID: String)
}
