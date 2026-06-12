//
//  MockVIPEROutputs.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
import Foundation
import UIKit
@testable import TheNews

final class MockArticlesInteractorOutput: ArticlesInteractorOutputProtocol {

    var didStartLoadingCalls: [Bool] = []
    var didFinishLoadingCount = 0
    var fetchedArticles: [(articles: [Article], refresh: Bool, hasMore: Bool)] = []
    var lastError: Error?

    func didStartLoading(refresh: Bool) {
        didStartLoadingCalls.append(refresh)
    }

    func didFinishLoading() {
        didFinishLoadingCount += 1
    }

    func didFetchArticles(_ articles: [Article], refresh: Bool, hasMore: Bool) {
        fetchedArticles.append((articles, refresh, hasMore))
    }

    func didFail(with error: Error) {
        lastError = error
    }
}

final class MockArticlesView: ArticlesViewProtocol {

    var showLoadingCount = 0
    var hideLoadingCount = 0
    var displayedArticles: [Article] = []
    var showEmptyStateCount = 0
    var lastErrorMessage: String?
    var showLoadMoreIndicatorCount = 0
    var hideLoadMoreIndicatorCount = 0

    func showLoading() { showLoadingCount += 1 }
    func hideLoading() { hideLoadingCount += 1 }
    func showArticles(_ articles: [Article]) { displayedArticles = articles }
    func showEmptyState() { showEmptyStateCount += 1 }
    func showError(_ message: String) { lastErrorMessage = message }
    func showLoadMoreIndicator() { showLoadMoreIndicatorCount += 1 }
    func hideLoadMoreIndicator() { hideLoadMoreIndicatorCount += 1 }
}

final class MockArticlesRouter: ArticlesRouterProtocol {

    static func createModule(sourceID: String, container: DIContainer) -> UIViewController {
        UIViewController()
    }

    var navigatedURL: URL?
    var navigatedTitle: String?

    func navigateToArticleDetail(url: URL, title: String) {
        navigatedURL = url
        navigatedTitle = title
    }
}

final class MockSourcesInteractorOutput: SourcesInteractorOutputProtocol {

    var didStartLoadingCount = 0
    var didFinishLoadingCount = 0
    var fetchedSources: [NewsSource] = []
    var updatedFilteredSources: [[NewsSource]] = []
    var loadedMoreSources: [[NewsSource]] = []
    var lastError: Error?

    func didStartLoading() { didStartLoadingCount += 1 }
    func didFinishLoading() { didFinishLoadingCount += 1 }

    func didFetchSources(_ sources: [NewsSource]) {
        fetchedSources = sources
    }

    func didUpdateFilteredSources(_ sources: [NewsSource]) {
        updatedFilteredSources.append(sources)
    }

    func didLoadMoreSources(_ sources: [NewsSource]) {
        loadedMoreSources.append(sources)
    }

    func didFail(with error: Error) {
        lastError = error
    }
}

final class MockSourcesView: SourcesViewProtocol {

    var showLoadingCount = 0
    var hideLoadingCount = 0
    var displayedSources: [NewsSource] = []
    var showEmptyStateCount = 0
    var lastErrorMessage: String?
    var showLoadMoreIndicatorCount = 0
    var hideLoadMoreIndicatorCount = 0

    func showLoading() { showLoadingCount += 1 }
    func hideLoading() { hideLoadingCount += 1 }
    func showSources(_ sources: [NewsSource]) { displayedSources = sources }
    func showEmptyState() { showEmptyStateCount += 1 }
    func showError(_ message: String) { lastErrorMessage = message }
    func showLoadMoreIndicator() { showLoadMoreIndicatorCount += 1 }
    func hideLoadMoreIndicator() { hideLoadMoreIndicatorCount += 1 }
}

final class MockSourcesRouter: SourcesRouterProtocol {

    static func createModule(category: String, container: DIContainer) -> UIViewController {
        UIViewController()
    }

    var navigatedSourceID: String?

    func navigateToArticles(sourceID: String) {
        navigatedSourceID = sourceID
    }
}

final class MockCategoriesInteractorOutput: CategoriesInteractorOutputProtocol {

    var fetchedCategories: [String] = []

    func didFetchCategories(_ categories: [String]) {
        fetchedCategories = categories
    }
}

final class MockCategoriesView: CategoriesViewProtocol {

    var displayedCategories: [String] = []

    func showCategories(_ categories: [String]) {
        displayedCategories = categories
    }
}

final class MockCategoriesRouter: CategoriesRouterProtocol {

    static func createModule(container: DIContainer) -> UIViewController {
        UIViewController()
    }

    var navigatedCategory: String?

    func navigateToSources(category: String) {
        navigatedCategory = category
    }
}
