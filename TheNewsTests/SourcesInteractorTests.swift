//
//  SourcesInteractorTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

@Suite(.serialized)
@MainActor
struct SourcesInteractorTests {

    @Test func fetchSources_success_deliversFirstPage() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchSourcesResult = .success(TestFixtures.sourceResponse(sourceCount: 25))
        let output = MockSourcesInteractorOutput()
        let interactor = SourcesInteractor(category: TestFixtures.sampleCategory, apiService: mockAPI)
        interactor.output = output

        interactor.fetchSources(category: TestFixtures.sampleCategory)

        await AutoLayoutTestHelpers.waitUntil { !output.updatedFilteredSources.isEmpty }

        #expect(output.didStartLoadingCount == 1)
        #expect(output.didFinishLoadingCount == 1)
        #expect(output.updatedFilteredSources[0].count == 20)
        #expect(mockAPI.fetchSourcesCalls == [TestFixtures.sampleCategory])
    }

    @Test func fetchSources_failure_deliversError() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchSourcesResult = .failure(APIError.decodingFailed)
        let output = MockSourcesInteractorOutput()
        let interactor = SourcesInteractor(category: TestFixtures.sampleCategory, apiService: mockAPI)
        interactor.output = output

        interactor.fetchSources(category: TestFixtures.sampleCategory)

        await AutoLayoutTestHelpers.waitUntil { output.lastError != nil }

        #expect((output.lastError as? APIError)?.errorDescription == APIError.decodingFailed.errorDescription)
    }

    @Test func filterSources_matchesNameCaseInsensitively() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchSourcesResult = .success(
            SourceResponse(
                status: "ok",
                sources: [
                    NewsSource(id: "bbc", name: "BBC News"),
                    NewsSource(id: "cnn", name: "CNN"),
                    NewsSource(id: "tc", name: "TechCrunch")
                ]
            )
        )
        let output = MockSourcesInteractorOutput()
        let interactor = SourcesInteractor(category: TestFixtures.sampleCategory, apiService: mockAPI)
        interactor.output = output

        interactor.fetchSources(category: TestFixtures.sampleCategory)
        await AutoLayoutTestHelpers.waitUntil { !output.updatedFilteredSources.isEmpty }

        interactor.filterSources(query: "tech")
        await AutoLayoutTestHelpers.waitUntil { output.updatedFilteredSources.count >= 2 }

        #expect(output.updatedFilteredSources[1].count == 1)
        #expect(output.updatedFilteredSources[1][0].name == "TechCrunch")
    }

    @Test func loadMoreSources_deliversNextPage() async {
        let mockAPI = MockNewsAPIService()
        mockAPI.fetchSourcesResult = .success(TestFixtures.sourceResponse(sourceCount: 45))
        let output = MockSourcesInteractorOutput()
        let interactor = SourcesInteractor(category: TestFixtures.sampleCategory, apiService: mockAPI)
        interactor.output = output

        interactor.fetchSources(category: TestFixtures.sampleCategory)
        await AutoLayoutTestHelpers.waitUntil { !output.updatedFilteredSources.isEmpty }

        interactor.loadMoreSources()
        await AutoLayoutTestHelpers.waitUntil { !output.loadedMoreSources.isEmpty }

        #expect(output.loadedMoreSources[0].count == 40)
    }
}
