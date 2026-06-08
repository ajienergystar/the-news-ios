//
//  NewsAPIServiceTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import Foundation
@testable import TheNews

@Suite(.serialized)
struct NewsAPIServiceTests {

    @Test func fetchArticles_decodesValidResponse() async throws {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)
        let jsonData = Data(TestFixtures.validNewsResponseJSON.utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        let result = try await service.fetchArticles(source: TestFixtures.sampleSourceID, page: 1)

        #expect(result.status == "ok")
        #expect(result.articles.count == 2)
    }

    @Test func fetchSources_decodesValidResponse() async throws {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)
        let jsonData = Data(TestFixtures.validSourceResponseJSON.utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        let result = try await service.fetchSources(category: TestFixtures.sampleCategory)

        #expect(result.status == "ok")
        #expect(result.sources.count == 3)
        #expect(result.sources[0].id == "bbc-news")
    }

    @Test func searchArticles_includesQueryParameter() async throws {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)
        let jsonData = Data(TestFixtures.validNewsResponseJSON.utf8)
        var capturedURL: URL?

        MockURLProtocol.requestHandler = { request in
            capturedURL = request.url
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        _ = try await service.searchArticles(query: "swift", page: 2)

        let query = capturedURL.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems }
        #expect(query?.contains(where: { $0.name == "q" && $0.value == "swift" }) == true)
        #expect(query?.contains(where: { $0.name == "page" && $0.value == "2" }) == true)
        #expect(query?.contains(where: { $0.name == "pageSize" && $0.value == "\(Constants.pageSize)" }) == true)
    }

    @Test func request_throwsServerMessageOnErrorStatus() async {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)
        let jsonData = Data(TestFixtures.apiErrorResponseJSON.utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }

        do {
            _ = try await service.fetchArticles(source: TestFixtures.sampleSourceID, page: 1)
            Issue.record("Expected APIError.serverMessage to be thrown")
        } catch let error as APIError {
            #expect(error.errorDescription == "Your API key is invalid.")
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func request_throwsDecodingFailedForInvalidJSON() async {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("{ invalid json }".utf8))
        }

        do {
            _ = try await service.fetchArticles(source: TestFixtures.sampleSourceID, page: 1)
            Issue.record("Expected APIError.decodingFailed to be thrown")
        } catch let error as APIError {
            if case .decodingFailed = error {
                // expected
            } else {
                Issue.record("Expected decodingFailed, got \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func request_throwsNoInternetForOfflineError() async {
        let session = MockURLSessionFactory.makeSession()
        let service = NewsAPIService(session: session)

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            _ = try await service.fetchArticles(source: TestFixtures.sampleSourceID, page: 1)
            Issue.record("Expected APIError.noInternet to be thrown")
        } catch let error as APIError {
            if case .noInternet = error {
                // expected
            } else {
                Issue.record("Expected noInternet, got \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
