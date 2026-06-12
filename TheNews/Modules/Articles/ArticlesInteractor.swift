//
//  ArticlesInteractor.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class ArticlesInteractor: ArticlesInteractorProtocol {

    weak var output: ArticlesInteractorOutputProtocol?

    private let apiService: NewsAPIServiceProtocol
    private let sourceID: String
    private var currentPage = 1
    private var searchQuery = ""
    private var allArticles: [Article] = []
    private var isFetching = false

    init(sourceID: String, apiService: NewsAPIServiceProtocol) {
        self.sourceID = sourceID
        self.apiService = apiService
    }

    func fetchArticles(refresh: Bool) {
        guard !isFetching else { return }

        if refresh {
            currentPage = 1
            searchQuery = ""
        }

        isFetching = true
        output?.didStartLoading(refresh: refresh)

        Task {
            do {
                let response = try await apiService.fetchArticles(source: sourceID, page: currentPage)
                let hasMore = response.articles.count >= Constants.pageSize

                await MainActor.run {
                    if refresh {
                        allArticles = response.articles
                    } else {
                        allArticles.append(contentsOf: response.articles)
                    }

                    if !response.articles.isEmpty {
                        currentPage += 1
                    }

                    output?.didFinishLoading()
                    output?.didFetchArticles(allArticles, refresh: refresh, hasMore: hasMore)
                    isFetching = false
                }
            } catch {
                await MainActor.run {
                    output?.didFinishLoading()
                    output?.didFail(with: error)
                    isFetching = false
                }
            }
        }
    }

    func searchArticles(query: String) {
        searchQuery = query
        currentPage = 1
        isFetching = true
        output?.didStartLoading(refresh: true)

        Task {
            do {
                let response: NewsResponse
                if query.isEmpty {
                    response = try await apiService.fetchArticles(source: sourceID, page: 1)
                } else {
                    response = try await apiService.searchArticles(query: query, page: 1)
                }

                let hasMore = response.articles.count >= Constants.pageSize

                await MainActor.run {
                    allArticles = response.articles
                    currentPage = 2
                    output?.didFinishLoading()
                    output?.didFetchArticles(allArticles, refresh: true, hasMore: hasMore)
                    isFetching = false
                }
            } catch {
                await MainActor.run {
                    output?.didFinishLoading()
                    output?.didFail(with: error)
                    isFetching = false
                }
            }
        }
    }

    func loadMoreArticles() {
        guard !isFetching, !searchQuery.isEmpty || !allArticles.isEmpty else { return }

        isFetching = true
        output?.didStartLoading(refresh: false)

        Task {
            do {
                let response: NewsResponse
                if searchQuery.isEmpty {
                    response = try await apiService.fetchArticles(source: sourceID, page: currentPage)
                } else {
                    response = try await apiService.searchArticles(query: searchQuery, page: currentPage)
                }

                let hasMore = response.articles.count >= Constants.pageSize

                await MainActor.run {
                    allArticles.append(contentsOf: response.articles)

                    if !response.articles.isEmpty {
                        currentPage += 1
                    }

                    output?.didFinishLoading()
                    output?.didFetchArticles(allArticles, refresh: false, hasMore: hasMore)
                    isFetching = false
                }
            } catch {
                await MainActor.run {
                    output?.didFinishLoading()
                    output?.didFail(with: error)
                    isFetching = false
                }
            }
        }
    }
}
