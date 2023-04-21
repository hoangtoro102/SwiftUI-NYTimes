//
//  ArticleService.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Combine
import Foundation
import SwiftUI

typealias PageDisplayItem = ([DisplayItem], PageInfo)

protocol ArticleService {
    func get(articles: LoadableSubject<PageDisplayItem>, type: PopularAPI)
    func search(articles: LoadableSubject<PageDisplayItem>, text: String)
}

struct DefaultArticleService: ArticleService {
    let popularNetworkUsecase: PopularArticlesUseCase
    let popularDBUsecase: PopularArticlesDBUseCase
    let searchUsecase: SearchArticlesUseCase
    
    init(popularNetworkUsecase: PopularArticlesUseCase,
         popularDBUsecase: PopularArticlesDBUseCase,
         searchUsecase: SearchArticlesUseCase
    ) {
        self.popularNetworkUsecase = popularNetworkUsecase
        self.popularDBUsecase = popularDBUsecase
        self.searchUsecase = searchUsecase
    }

    func get(articles: LoadableSubject<PageDisplayItem>, type: PopularAPI) {
//        let cancelBag = CancelBag()
//        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
//        popularNetworkUsecase.loadArticles(target: type)
//            .map{$0.map{DisplayItem(popularArticle: $0)}}
//            .sinkToLoadable { articles.wrappedValue = $0 }
//            .store(in: cancelBag)
        
        loadDBBeforeLoadingAPI(articles: articles, type: type)
//        loadAPIBeforeLoadingDB(articles: articles, type: type)
    }
    
    private func loadAPIBeforeLoadingDB(articles: LoadableSubject<PageDisplayItem>, type: PopularAPI) {
        let cancelBag = CancelBag()
        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [popularNetworkUsecase] in
                popularNetworkUsecase
                    .loadArticles(target: type)
                    .ensureTimeSpan(requestHoldBackTimeInterval)
            }
            .flatMap { [popularDBUsecase] articles -> AnyPublisher<PageDisplayItem, Error> in
                if articles.count > 0 {
                    return cleanAndStore(articles)
                        .flatMap { Just.withErrorType(articles, Error.self) }
                        .map{$0.map{DisplayItem(popularArticle: $0)}}
                        .map{($0, PageInfo())}
                        .eraseToAnyPublisher()
                } else {
                    return popularDBUsecase.fetch()
                        .map{$0.map{DisplayItem(popularArticle: $0)}}
                        .map{($0, PageInfo())}
                        .eraseToAnyPublisher()
                }
            }
            .sinkToLoadable { articles.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    private func loadDBBeforeLoadingAPI(articles: LoadableSubject<PageDisplayItem>, type: PopularAPI) {
        let cancelBag = CancelBag()
        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
    
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [popularDBUsecase] _ -> AnyPublisher<Bool, Error> in
                popularDBUsecase.hasLoadedArticles()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshArticleList(type)
                }
            }
            .flatMap { [popularDBUsecase] in
                popularDBUsecase.fetch()
            }
            .map{$0.map{DisplayItem(popularArticle: $0)}}
            .map{($0, PageInfo())}
            .sinkToLoadable { articles.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    private func refreshArticleList(_ type: PopularAPI) -> AnyPublisher<Void, Error> {
        return popularNetworkUsecase.loadArticles(target: type)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .flatMap { cleanAndStore($0) }
            .eraseToAnyPublisher()
    }
    
    private func cleanAndStore(_ articles: [Article]) -> AnyPublisher<Void, Error> {
        return popularDBUsecase.deleteAll()
            .flatMap { [popularDBUsecase] in
                popularDBUsecase.store(articles: articles)
            }
            .eraseToAnyPublisher()
    }
    
    func search(articles: LoadableSubject<PageDisplayItem>, text: String) {
        let cancelBag = CancelBag()
        // Set the last value before loading
        articles.wrappedValue.setIsLoading(cancelBag: cancelBag)
        searchUsecase.search(text: text, page: articles.wrappedValue.value?.1.page ?? 0)
            .map{$0.map{DisplayItem(searchArticle: $0)}}
            .map { result -> PageDisplayItem in
                var pageInfo = articles.wrappedValue.value?.1 ?? .init(page: 0)
                pageInfo.page += 1
                let existingArticles = articles.wrappedValue.value?.0 ?? []
                return (existingArticles + result, pageInfo)
            }
            .sinkToLoadable { articles.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubArticleService: ArticleService {
    func get(articles: LoadableSubject<PageDisplayItem>, type: PopularAPI) {}
    func search(articles: LoadableSubject<PageDisplayItem>, text: String) {}
}

struct StubValidationService: ValidationService {
    func validate(email: String) -> AnyPublisher<String, Error> {
        return Just(email)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
    }
    func validate(password: String) -> AnyPublisher<String, Error> {
        return Just(password)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
    }
}
