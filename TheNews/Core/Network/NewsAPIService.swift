//
//  NewsAPIService.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

protocol NewsAPIServiceProtocol {
    func fetchSources(category: String) async throws -> SourceResponse
    func fetchArticles(source: String, page: Int) async throws -> NewsResponse
    func searchArticles(query: String, page: Int) async throws -> NewsResponse
}

final class NewsAPIService: NewsAPIServiceProtocol {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetchSources(category: String) async throws -> SourceResponse {
        try await request(
            endpoint: "sources",
            parameters: ["category": category]
        )
    }

    func fetchArticles(source: String, page: Int) async throws -> NewsResponse {
        try await request(
            endpoint: "everything",
            parameters: [
                "sources": source,
                "page": page,
                "pageSize": Constants.pageSize
            ]
        )
    }

    func searchArticles(query: String, page: Int) async throws -> NewsResponse {
        try await request(
            endpoint: "everything",
            parameters: [
                "q": query,
                "page": page,
                "pageSize": Constants.pageSize
            ]
        )
    }

    private func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any]
    ) async throws -> T {
        guard var components = URLComponents(string: Constants.baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var queryItems = [URLQueryItem(name: "apiKey", value: Constants.apiKey)]
        queryItems.append(contentsOf: parameters.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw APIError.noInternet
        } catch {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(NewsAPIErrorResponse.self, from: data) {
                throw APIError.serverMessage(apiError.message)
            }
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}

private struct NewsAPIErrorResponse: Decodable {
    let message: String
}
