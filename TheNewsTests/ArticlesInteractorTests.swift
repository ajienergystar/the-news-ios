//
//  ArticlesInteractorTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

@Suite(.serialized)
@MainActor
struct ArticlesInteractorTests {

    @Test func fetchArticles_refreshSuccess_deliversArticles() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 20))
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.fetchArticles(refresh: true)

        await AutoLayoutTestHelpers.waitUntil { !output.fetchedArticles.isEmpty }

        #expect(output.didStartLoadingCalls == [true])
        #expect(output.didFinishLoadingCount == 1)
        #expect(output.fetchedArticles.count == 1)
        #expect(output.fetchedArticles[0].articles.count == 20)
        #expect(output.fetchedArticles[0].refresh == true)
        #expect(output.fetchedArticles[0].hasMore == true)
        #expect(mockAPI.fetchArticlesCalls.count == 1)
        #expect(mockAPI.fetchArticlesCalls[0].source == TestFixtures.sampleSourceID)
        #expect(mockAPI.fetchArticlesCalls[0].page == 1)
    }

    @Test func fetchArticles_partialPage_indicatesNoMorePages() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 5))
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.fetchArticles(refresh: true)

        await AutoLayoutTestHelpers.waitUntil { !output.fetchedArticles.isEmpty }

        #expect(output.fetchedArticles[0].hasMore == false)
    }

    @Test func fetchArticles_failure_deliversError() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchArticlesResult = .failure(APIError.noInternet)
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.fetchArticles(refresh: true)

        await AutoLayoutTestHelpers.waitUntil { output.lastError != nil }

        #expect((output.lastError as? APIError)?.errorDescription == APIError.noInternet.errorDescription)
        #expect(output.didFinishLoadingCount == 1)
    }

    @Test func searchArticles_withQuery_usesSearchEndpoint() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.searchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 3))
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.searchArticles(query: "iOS")

        await AutoLayoutTestHelpers.waitUntil { !output.fetchedArticles.isEmpty }

        #expect(mockAPI.searchArticlesCalls.count == 1)
        #expect(mockAPI.searchArticlesCalls[0].query == "iOS")
        #expect(mockAPI.searchArticlesCalls[0].page == 1)
        #expect(output.fetchedArticles[0].articles.count == 3)
        #expect(output.fetchedArticles[0].refresh == true)
    }

    @Test func searchArticles_emptyQuery_fetchesArticlesInstead() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 10))
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.searchArticles(query: "")

        await AutoLayoutTestHelpers.waitUntil { !output.fetchedArticles.isEmpty }

        #expect(mockAPI.fetchArticlesCalls.count == 1)
        #expect(mockAPI.fetchArticlesCalls[0].source == TestFixtures.sampleSourceID)
        #expect(mockAPI.fetchArticlesCalls[0].page == 1)
        #expect(mockAPI.searchArticlesCalls.isEmpty)
    }

    @Test func loadMoreArticles_appendsNextPage() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 20))
        let output = MockArticlesInteractorOutput()
        let interactor = ArticlesInteractor(sourceID: TestFixtures.sampleSourceID, apiService: mockAPI)
        interactor.output = output

        interactor.fetchArticles(refresh: true)
        await AutoLayoutTestHelpers.waitUntil { !output.fetchedArticles.isEmpty }

        mockAPI.fetchArticlesResult = .success(TestFixtures.newsResponse(articleCount: 15))
        interactor.loadMoreArticles()
        await AutoLayoutTestHelpers.waitUntil { output.fetchedArticles.count >= 2 }

        #expect(output.fetchedArticles[1].articles.count == 35)
        #expect(output.fetchedArticles[1].refresh == false)
        #expect(mockAPI.fetchArticlesCalls.contains(where: { $0.page == 2 }))
    }
}
