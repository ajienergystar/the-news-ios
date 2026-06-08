//
//  ArticleTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import Foundation
@testable import TheNews

struct ArticleTests {

    @Test func decodeNewsResponse_fromValidJSON() throws {
        let data = Data(TestFixtures.validNewsResponseJSON.utf8)

        let response = try JSONDecoder().decode(NewsResponse.self, from: data)

        #expect(response.status == "ok")
        #expect(response.totalResults == 2)
        #expect(response.articles.count == 2)
        #expect(response.articles[0].title == "Apple unveils new AI features at WWDC")
        #expect(response.articles[0].source.name == "BBC News")
        #expect(response.articles[1].author == nil)
        #expect(response.articles[1].urlToImage == nil)
    }

    @Test func decodeSourceResponse_fromValidJSON() throws {
        let data = Data(TestFixtures.validSourceResponseJSON.utf8)

        let response = try JSONDecoder().decode(SourceResponse.self, from: data)

        #expect(response.status == "ok")
        #expect(response.sources.count == 3)
        #expect(response.sources[0].id == "bbc-news")
        #expect(response.sources[1].name == "CNN")
    }

    @Test func article_id_equalsURL() {
        let article = TestFixtures.sampleArticle

        #expect(article.id == article.url)
        #expect(article.id == "https://www.bbc.com/news/technology-12345678")
    }

    @Test func article_imageURL_returnsValidURL() {
        let article = TestFixtures.sampleArticle

        #expect(article.imageURL?.absoluteString == "https://ichef.bbci.co.uk/news/660/cpsprodpb/example.jpg")
    }

    @Test func article_imageURL_nilWhenMissing() {
        let article = TestFixtures.sampleArticleWithoutImage

        #expect(article.imageURL == nil)
    }

    @Test func article_articleURL_returnsValidURL() {
        let article = TestFixtures.sampleArticle

        #expect(article.articleURL?.absoluteString == article.url)
    }

    @Test func article_formattedDate_formatsValidDateString() {
        let article = TestFixtures.sampleArticle

        #expect(article.formattedDate == "Jun 8, 2024")
    }

    @Test func formattedNewsDate_returnsOriginalForInvalidInput() {
        let invalidDate = "not-a-date"

        #expect(invalidDate.formattedNewsDate() == invalidDate)
    }

    @Test func article_isHashable() {
        let article1 = TestFixtures.sampleArticle
        let article2 = TestFixtures.sampleArticle
        let set: Set<Article> = [article1, article2]

        #expect(set.count == 1)
    }

    @Test func newsSource_handlesOptionalFields() {
        let source = NewsSource(id: nil, name: nil)

        #expect(source.id == nil)
        #expect(source.name == nil)
    }
}
