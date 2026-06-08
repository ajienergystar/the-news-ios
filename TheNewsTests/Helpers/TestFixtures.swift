//
//  TestFixtures.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
@testable import TheNews

enum TestFixtures {

    static let sampleSourceID = "bbc-news"
    static let sampleCategory = "technology"

    static let sampleArticle = Article(
        source: NewsSource(id: "bbc-news", name: "BBC News"),
        author: "Jane Smith",
        title: "Apple unveils new AI features at WWDC",
        description: "The company announced major updates to its operating systems.",
        url: "https://www.bbc.com/news/technology-12345678",
        urlToImage: "https://ichef.bbci.co.uk/news/660/cpsprodpb/example.jpg",
        publishedAt: "2024-06-08T10:30:00+0000",
        content: "Apple has unveiled a suite of new AI-powered features..."
    )

    static let sampleArticleWithoutImage = Article(
        source: NewsSource(id: "techcrunch", name: "TechCrunch"),
        author: nil,
        title: "Startup raises $50M in Series B",
        description: nil,
        url: "https://techcrunch.com/2024/06/08/startup-funding",
        urlToImage: nil,
        publishedAt: "2024-06-08T14:00:00+0000",
        content: nil
    )

    static func makeArticles(count: Int, prefix: String = "Article") -> [Article] {
        (0..<count).map { index in
            Article(
                source: NewsSource(id: "source-\(index)", name: "Source \(index)"),
                author: "Author \(index)",
                title: "\(prefix) \(index + 1)",
                description: "Description for \(prefix) \(index + 1)",
                url: "https://example.com/\(prefix.lowercased())-\(index + 1)",
                urlToImage: index.isMultiple(of: 2) ? "https://example.com/image-\(index).jpg" : nil,
                publishedAt: "2024-06-08T10:30:00+0000",
                content: "Content \(index + 1)"
            )
        }
    }

    static func newsResponse(articleCount: Int, totalResults: Int? = nil) -> NewsResponse {
        NewsResponse(
            status: "ok",
            totalResults: totalResults ?? articleCount,
            articles: makeArticles(count: articleCount)
        )
    }

    static func sourceResponse(sourceCount: Int) -> SourceResponse {
        SourceResponse(
            status: "ok",
            sources: makeSources(count: sourceCount)
        )
    }

    static func makeSources(count: Int) -> [NewsSource] {
        (0..<count).map { index in
            NewsSource(id: "source-\(index)", name: "News Source \(index)")
        }
    }

    static let validNewsResponseJSON = """
    {
        "status": "ok",
        "totalResults": 2,
        "articles": [
            {
                "source": { "id": "bbc-news", "name": "BBC News" },
                "author": "Jane Smith",
                "title": "Apple unveils new AI features at WWDC",
                "description": "Major updates announced.",
                "url": "https://www.bbc.com/news/technology-12345678",
                "urlToImage": "https://ichef.bbci.co.uk/news/660/example.jpg",
                "publishedAt": "2024-06-08T10:30:00+0000",
                "content": "Full article content here."
            },
            {
                "source": { "id": "techcrunch", "name": "TechCrunch" },
                "author": null,
                "title": "Startup raises $50M",
                "description": null,
                "url": "https://techcrunch.com/2024/06/08/funding",
                "urlToImage": null,
                "publishedAt": "2024-06-08T14:00:00+0000",
                "content": null
            }
        ]
    }
    """

    static let validSourceResponseJSON = """
    {
        "status": "ok",
        "sources": [
            { "id": "bbc-news", "name": "BBC News" },
            { "id": "cnn", "name": "CNN" },
            { "id": "techcrunch", "name": "TechCrunch" }
        ]
    }
    """

    static let apiErrorResponseJSON = """
    {
        "status": "error",
        "code": "apiKeyInvalid",
        "message": "Your API key is invalid."
    }
    """
}
