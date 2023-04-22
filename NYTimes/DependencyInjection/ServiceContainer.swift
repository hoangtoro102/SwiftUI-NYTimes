//
//  ServiceContainer.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

extension DIContainer {
    struct Services {
        let articleService: ArticleService
        let validationService: ValidationService
        
        init(articleService: ArticleService, validationService: ValidationService) {
            self.articleService = articleService
            self.validationService = validationService
        }
        
        static var stub: Self {
            .init(articleService: StubArticleService(),
                  validationService: StubValidationService())
        }
    }
}
