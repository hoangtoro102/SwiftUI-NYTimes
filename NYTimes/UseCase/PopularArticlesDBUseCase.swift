//
//  ArticlesDBUseCase.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 2/13/23.
//

import CoreData
import Combine

protocol PopularArticlesDBUseCase {
    func hasLoadedArticles() -> AnyPublisher<Bool, Error>
    
    func store(articles: [Article]) -> AnyPublisher<Void, Error>
    func fetch() -> AnyPublisher<LazyList<Article>, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}

struct DefaultArticlesDBUseCase: PopularArticlesDBUseCase {
    
    let persistentStore: PersistentStore
    
    func hasLoadedArticles() -> AnyPublisher<Bool, Error> {
        let fetchRequest = ArticleMO.justOneArticle()
        return persistentStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    func store(articles: [Article]) -> AnyPublisher<Void, Error> {
        return persistentStore
            .update { context in
                articles.forEach {
                    $0.store(in: context)
                }
            }
    }
    
    func fetch() -> AnyPublisher<LazyList<Article>, Error> {
        let fetchRequest = ArticleMO.articles()
        return persistentStore
            .fetch(fetchRequest) {
                Article(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        return persistentStore.deleteAll()
    }
}

// MARK: - Fetch Requests

extension ArticleMO {
    static func justOneArticle() -> NSFetchRequest<ArticleMO> {
        let request = newFetchRequest()
        request.fetchLimit = 1
        return request
    }
    
    static func articles() -> NSFetchRequest<ArticleMO> {
        let request = newFetchRequest()
        return request
    }
}
