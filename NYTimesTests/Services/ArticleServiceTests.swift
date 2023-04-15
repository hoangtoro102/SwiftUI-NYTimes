//
//  ArticleServiceTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import SwiftUI
import Combine
@testable import NYTimes

class ArticlesServiceTests: XCTestCase {
    var mockedPopularUseCase: MockedPopularArticlesUseCase!
    var mockedSearchUseCase: MockedSearchArticlesUseCase!
    var subscriptions = Set<AnyCancellable>()
    var sut: DefaultArticleService!

    override func setUp() {
        mockedPopularUseCase = MockedPopularArticlesUseCase()
        mockedSearchUseCase = MockedSearchArticlesUseCase()
        sut = DefaultArticleService(popularUsecase: mockedPopularUseCase, searchUsecase: mockedSearchUseCase)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
}

// MARK:
final class LoadArticlesTests: ArticlesServiceTests {
    
    func test_stubService() {
        let sut = StubArticleService()
        let articles = BindingWithPublisher(value: Loadable<[DisplayItem]>.notRequested)
        sut.get(articles: articles.binding, type: .mostViewed)
        let searchArticles = BindingWithPublisher(value: Loadable<[SearchArticle]>.notRequested)
        sut.search(articles: searchArticles.binding, text: "")
    }
}
