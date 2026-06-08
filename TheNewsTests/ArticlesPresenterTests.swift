//
//  ArticlesPresenterTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

@MainActor
struct ArticlesPresenterTests {

    @Test func viewDidLoad_fetchesArticles() {
        let presenter = ArticlesPresenter()
        let mockInteractor = MockArticlesInteractor()
        presenter.interactor = mockInteractor

        presenter.viewDidLoad()

        #expect(mockInteractor.fetchArticlesCalls == [true])
    }

    @Test func didSelectArticle_navigatesWithURLAndTitle() {
        let presenter = ArticlesPresenter()
        let mockRouter = MockArticlesRouter()
        presenter.router = mockRouter

        presenter.didSelectArticle(TestFixtures.sampleArticle)

        #expect(mockRouter.navigatedURL?.absoluteString == TestFixtures.sampleArticle.url)
        #expect(mockRouter.navigatedTitle == TestFixtures.sampleArticle.title)
    }

    @Test func didSelectArticle_invalidURL_doesNotNavigate() {
        let presenter = ArticlesPresenter()
        let mockRouter = MockArticlesRouter()
        presenter.router = mockRouter
        let invalidArticle = Article(
            source: NewsSource(id: "test", name: "Test"),
            author: nil,
            title: "Invalid",
            description: nil,
            url: "",
            urlToImage: nil,
            publishedAt: "2024-06-08T10:30:00+0000",
            content: nil
        )

        presenter.didSelectArticle(invalidArticle)

        #expect(mockRouter.navigatedURL == nil)
    }

    @Test func didReachEndOfList_whenHasMore_showsIndicatorAndLoadsMore() {
        let presenter = ArticlesPresenter()
        let mockView = MockArticlesView()
        let mockInteractor = MockArticlesInteractor()
        presenter.view = mockView
        presenter.interactor = mockInteractor

        presenter.didFetchArticles(TestFixtures.makeArticles(count: 20), refresh: true, hasMore: true)
        presenter.didReachEndOfList()

        #expect(mockView.showLoadMoreIndicatorCount == 1)
        #expect(mockInteractor.loadMoreArticlesCalled == true)
    }

    @Test func didReachEndOfList_whenNoMore_doesNothing() {
        let presenter = ArticlesPresenter()
        let mockView = MockArticlesView()
        let mockInteractor = MockArticlesInteractor()
        presenter.view = mockView
        presenter.interactor = mockInteractor

        presenter.didFetchArticles(TestFixtures.makeArticles(count: 5), refresh: true, hasMore: false)
        presenter.didReachEndOfList()

        #expect(mockView.showLoadMoreIndicatorCount == 0)
        #expect(mockInteractor.loadMoreArticlesCalled == false)
    }

    @Test func didFetchArticles_empty_showsEmptyState() {
        let presenter = ArticlesPresenter()
        let mockView = MockArticlesView()
        presenter.view = mockView

        presenter.didFetchArticles([], refresh: true, hasMore: false)

        #expect(mockView.showEmptyStateCount == 1)
    }

    @Test func didFetchArticles_withData_showsArticles() {
        let presenter = ArticlesPresenter()
        let mockView = MockArticlesView()
        presenter.view = mockView
        let articles = TestFixtures.makeArticles(count: 3)

        presenter.didFetchArticles(articles, refresh: true, hasMore: false)

        #expect(mockView.displayedArticles.count == 3)
    }

    @Test func didFail_showsErrorMessage() {
        let presenter = ArticlesPresenter()
        let mockView = MockArticlesView()
        presenter.view = mockView

        presenter.didFail(with: APIError.noInternet)

        #expect(mockView.lastErrorMessage == APIError.noInternet.errorDescription)
    }

    @Test func didTapRetry_refreshesArticles() {
        let presenter = ArticlesPresenter()
        let mockInteractor = MockArticlesInteractor()
        presenter.interactor = mockInteractor

        presenter.didTapRetry()

        #expect(mockInteractor.fetchArticlesCalls == [true])
    }
}

// MARK: - Mock Interactor

private final class MockArticlesInteractor: ArticlesInteractorProtocol {

    var fetchArticlesCalls: [Bool] = []
    var searchArticlesCalls: [String] = []
    var loadMoreArticlesCalled = false

    func fetchArticles(refresh: Bool) {
        fetchArticlesCalls.append(refresh)
    }

    func searchArticles(query: String) {
        searchArticlesCalls.append(query)
    }

    func loadMoreArticles() {
        loadMoreArticlesCalled = true
    }
}
