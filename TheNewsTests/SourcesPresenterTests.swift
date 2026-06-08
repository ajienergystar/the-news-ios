//
//  SourcesPresenterTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

@MainActor
struct SourcesPresenterTests {

    @Test func viewDidLoad_fetchesSourcesForCategory() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockInteractor = MockSourcesInteractor()
        presenter.interactor = mockInteractor

        presenter.viewDidLoad()

        #expect(mockInteractor.fetchSourcesCalls == [TestFixtures.sampleCategory])
    }

    @Test func didSearch_filtersSources() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockInteractor = MockSourcesInteractor()
        presenter.interactor = mockInteractor

        presenter.didSearch(query: "BBC")

        #expect(mockInteractor.filterSourcesCalls == ["BBC"])
    }

    @Test func didCancelSearch_clearsFilter() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockInteractor = MockSourcesInteractor()
        presenter.interactor = mockInteractor

        presenter.didCancelSearch()

        #expect(mockInteractor.filterSourcesCalls == [""])
    }

    @Test func didSelectSource_navigatesWithSourceID() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockRouter = MockSourcesRouter()
        presenter.router = mockRouter
        let source = NewsSource(id: "bbc-news", name: "BBC News")

        presenter.didSelectSource(source)

        #expect(mockRouter.navigatedSourceID == "bbc-news")
    }

    @Test func didSelectSource_missingID_doesNotNavigate() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockRouter = MockSourcesRouter()
        presenter.router = mockRouter
        let source = NewsSource(id: nil, name: "Unknown")

        presenter.didSelectSource(source)

        #expect(mockRouter.navigatedSourceID == nil)
    }

    @Test func didUpdateFilteredSources_empty_showsEmptyState() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockView = MockSourcesView()
        presenter.view = mockView

        presenter.didUpdateFilteredSources([])

        #expect(mockView.showEmptyStateCount == 1)
        #expect(mockView.hideLoadMoreIndicatorCount == 1)
    }

    @Test func didFail_showsErrorMessage() {
        let presenter = SourcesPresenter(category: TestFixtures.sampleCategory)
        let mockView = MockSourcesView()
        presenter.view = mockView

        presenter.didFail(with: APIError.serverMessage("Server busy"))

        #expect(mockView.lastErrorMessage == "Server busy")
    }
}

private final class MockSourcesInteractor: SourcesInteractorProtocol {

    var fetchSourcesCalls: [String] = []
    var filterSourcesCalls: [String] = []
    var loadMoreSourcesCalled = false

    func fetchSources(category: String) {
        fetchSourcesCalls.append(category)
    }

    func filterSources(query: String) {
        filterSourcesCalls.append(query)
    }

    func loadMoreSources() {
        loadMoreSourcesCalled = true
    }
}
