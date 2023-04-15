//
//  MockedNetworkUseCases.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import XCTest
import Combine
@testable import NYTimes

class TestNetworkUseCase: NetworkUseCase {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = NetworkConstants.API_BASE_URL
    let bgQueue = DispatchQueue(label: "test")
}

final class MockedPopularArticlesUseCase: TestNetworkUseCase, Mock, PopularArticlesUseCase {
    enum Action: Equatable {
        case load(PopularAPI)
    }
    var actions = MockActions<Action>(expected: [])
    
    var articlesResponse: Result<[Article], Error> = .failure(MockError.valueNotSet)
    
    func loadArticles(target: PopularAPI) -> AnyPublisher<[Article], Error> {
        register(.load(target))
        return articlesResponse.publish()
    }
}

final class MockedSearchArticlesUseCase: TestNetworkUseCase, Mock, SearchArticlesUseCase {
    enum Action: Equatable {
        case search(String)
    }
    var actions = MockActions<Action>(expected: [])
    
    var articlesResponse: Result<[SearchArticle], Error> = .failure(MockError.valueNotSet)
    
    func search(text: String) -> AnyPublisher<[SearchArticle], Error> {
        register(.search(text))
        return articlesResponse.publish()
    }
}
