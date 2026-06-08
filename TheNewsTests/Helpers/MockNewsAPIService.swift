//
//  MockNewsAPIService.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation
@testable import TheNews

final class MockNewsAPIService: NewsAPIServiceProtocol {

    var fetchSourcesResult: Result<SourceResponse, Error> = .success(TestFixtures.sourceResponse(sourceCount: 3))
    var fetchArticlesResult: Result<NewsResponse, Error> = .success(TestFixtures.newsResponse(articleCount: 20))
    var searchArticlesResult: Result<NewsResponse, Error> = .success(TestFixtures.newsResponse(articleCount: 5))

    var fetchSourcesCalls: [String] = []
    var fetchArticlesCalls: [(source: String, page: Int)] = []
    var searchArticlesCalls: [(query: String, page: Int)] = []

    func fetchSources(category: String) async throws -> SourceResponse {
        fetchSourcesCalls.append(category)
        return try fetchSourcesResult.get()
    }

    func fetchArticles(source: String, page: Int) async throws -> NewsResponse {
        fetchArticlesCalls.append((source, page))
        return try fetchArticlesResult.get()
    }

    func searchArticles(query: String, page: Int) async throws -> NewsResponse {
        searchArticlesCalls.append((query, page))
        return try searchArticlesResult.get()
    }
}
