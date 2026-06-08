//
//  SourcesInteractor.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class SourcesInteractor: SourcesInteractorProtocol {

    weak var output: SourcesInteractorOutputProtocol?

    private let apiService: NewsAPIServiceProtocol
    private var category: String
    private var allSources: [NewsSource] = []
    private var displayedSources: [NewsSource] = []
    private var currentPage = 1
    private let pageSize = 20
    private var searchQuery = ""

    init(category: String, apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.category = category
        self.apiService = apiService
    }

    func fetchSources(category: String) {
        self.category = category
        currentPage = 1
        output?.didStartLoading()

        Task {
            do {
                let response = try await apiService.fetchSources(category: category)
                await MainActor.run {
                    allSources = response.sources
                    applyFilterAndPaginate(reset: true)
                    output?.didFinishLoading()
                }
            } catch {
                await MainActor.run {
                    output?.didFinishLoading()
                    output?.didFail(with: error)
                }
            }
        }
    }

    func filterSources(query: String) {
        searchQuery = query
        currentPage = 1
        applyFilterAndPaginate(reset: true)
    }

    func loadMoreSources() {
        guard hasMorePages else { return }
        currentPage += 1
        applyFilterAndPaginate(reset: false)
    }

    private var hasMorePages: Bool {
        let filtered = filteredSources
        return displayedSources.count < filtered.count
    }

    private var filteredSources: [NewsSource] {
        guard !searchQuery.isEmpty else { return allSources }
        return allSources.filter {
            $0.name?.lowercased().contains(searchQuery.lowercased()) ?? false
        }
    }

    private func applyFilterAndPaginate(reset: Bool) {
        let filtered = filteredSources
        let endIndex = min(currentPage * pageSize, filtered.count)
        let pageItems = Array(filtered.prefix(endIndex))

        if reset {
            displayedSources = pageItems
            output?.didUpdateFilteredSources(displayedSources)
        } else {
            displayedSources = pageItems
            output?.didLoadMoreSources(displayedSources)
        }
    }
}
