//
//  SearchArticlesUseCase.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Combine
import Foundation

protocol SearchArticlesUseCase: NetworkUseCase {
    func search(text: String, page: Int) -> AnyPublisher<[SearchArticle], Error>
}

struct DefaultSearchArticlesUseCase: SearchArticlesUseCase {
    
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func search(text: String, page: Int) -> AnyPublisher<[SearchArticle], Error> {
        print("Get search result with text: \(text)")
        return getResult(text: text, page: page)
            .compactMap(\.response?.docs)
            .eraseToAnyPublisher()
    }
    
    func getResult(text: String, page: Int) -> AnyPublisher<SearchResult, Error> {
        return call(endpoint: SearchAPI.search(text, page))
    }
}

// MARK: - Endpoints
typealias SearchAPI = DefaultSearchArticlesUseCase.API

extension DefaultSearchArticlesUseCase {
    enum API {
        case search(String, Int)
    }
}

extension SearchAPI: APICall {
    var path: String {
        switch self {
        case .search(let text, let page):
            return "/search/v2/articlesearch.json?q=\(text)&page=\(page)&api-key=\(NetworkConstants.API_KEY)"
        }
    }
    var method: String {
        return "GET"
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}
