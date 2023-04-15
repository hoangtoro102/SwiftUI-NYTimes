//
//  MockedData.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import Foundation

#if DEBUG

extension SearchResult {
    static let mockedData: SearchResult = .init(response: SearchResult.Response.mockedData)
}

extension SearchResult.Response {
    static let mockedData: SearchResult.Response = .init(docs: SearchArticle.mockedData)
}

extension PopularResult {
    static let mockedData: PopularResult = PopularResult(results: Article.mockedData)
}

extension Article {
    static let mockedData: [Article] = [
        Article(id: 1, title: "Title A", publishedDate: "12-12-2022"),
        Article(id: 2, title: "Title B", publishedDate: "11-11-2022"),
        Article(id: 3, title: "Title C", publishedDate: "10-10-2022"),
    ]
}

extension SearchArticle {
    static let mockedData: [SearchArticle] = [
        SearchArticle(id: "1", headline: Headline.mockedData, pubDate: "12-12-2022"),
        SearchArticle(id: "2", headline: Headline.mockedData, pubDate: "11-11-2022"),
        SearchArticle(id: "3", headline: Headline.mockedData, pubDate: "10-10-2022")
    ]
}

extension Headline {
    static let mockedData = Headline(main: "main", printHeadline: "print")
}

#endif
