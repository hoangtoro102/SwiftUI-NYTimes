//
//  ServiceContainer.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

extension DIContainer {
    struct Services {
        let articleService: ArticleService
        
        init(articleService: ArticleService) {
            self.articleService = articleService
        }
        
        static var stub: Self {
            .init(articleService: StubArticleService())
        }
    }
}
