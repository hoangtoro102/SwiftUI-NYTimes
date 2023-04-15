//
//  MockedServices.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import XCTest
import SwiftUI
import Combine
@testable import NYTimes

extension DIContainer.Services {
    static func mocked(articlesService: [MockedArticlesService.Action] = []) -> DIContainer.Services {
        .init(articleService: MockedArticlesService(expected: articlesService))
    }
    
    func verify(file: StaticString = #file, line: UInt = #line) {
        (articleService as? MockedArticlesService)?
            .verify(file: file, line: line)
    }
}

struct MockedArticlesService: Mock, ArticleService {
    
    enum Action: Equatable {
        case get(PopularAPI)
        case search(String)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func get(articles: LoadableSubject<[DisplayItem]>, type: PopularAPI) {
        register(.get(type))
    }
    
    func search(articles: LoadableSubject<[SearchArticle]>, text: String) {
        register(.search(text))
    }
}
