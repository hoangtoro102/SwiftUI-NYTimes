//
//  PopularArticlesUseCase.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Combine
import Foundation

protocol PopularArticlesUseCase: NetworkUseCase {
    func loadArticles(target: PopularAPI) -> AnyPublisher<[Article], Error>
}

struct DefaultPopularArticlesUseCase: PopularArticlesUseCase {
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadArticles(target: PopularAPI) -> AnyPublisher<[Article], Error> {
        return loadResult(target: target)
            .compactMap{$0.results}
            .eraseToAnyPublisher()
    }
    
    func loadResult(target: PopularAPI) -> AnyPublisher<PopularResult, Error> {
        return call(endpoint: target)
    }
}

// MARK: - Endpoints
typealias PopularAPI = DefaultPopularArticlesUseCase.API

extension DefaultPopularArticlesUseCase {
    enum API {
        case mostViewed
        case mostShared
        case mostEmailed
    }
}

extension DefaultPopularArticlesUseCase.API: APICall {
    var path: String {
        switch self {
        case .mostViewed:
            return "/mostpopular/v2/viewed/1.json?api-key=\(NetworkConstants.API_KEY)"
        case .mostShared:
            return "/mostpopular/v2/shared/1.json?api-key=\(NetworkConstants.API_KEY)"
        case .mostEmailed:
            return "/mostpopular/v2/emailed/1.json?api-key=\(NetworkConstants.API_KEY)"
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
