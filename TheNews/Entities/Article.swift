//
//  Article.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Hashable {
    let source: NewsSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    var id: String { url }

    var formattedDate: String {
        publishedAt.formattedNewsDate()
    }

    var imageURL: URL? {
        guard let urlToImage else { return nil }
        return URL(string: urlToImage)
    }

    var articleURL: URL? {
        URL(string: url)
    }
}

struct NewsSource: Decodable, Hashable {
    let id: String?
    let name: String?
}

struct SourceResponse: Decodable {
    let status: String
    let sources: [NewsSource]
}

extension String {
    func formattedNewsDate() -> String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = parser.date(from: self) else { return self }

        let display = DateFormatter()
        display.dateFormat = "MMM d, yyyy"
        return display.string(from: date)
    }
}
