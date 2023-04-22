//
//  AppEnvironment.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
    
    static func initialize() -> AppEnvironment {
        let session = configuredURLSession()
        let networkUseCases = configuredNetworkUseCases(session: session)
        let dbUseCases = configuredDBRepositories()
        let validationUseCases = configuredValidationUseCases()
        let services = configuredServices(networkUseCases: networkUseCases,
                                          dbUseCases: dbUseCases,
                                          validationUsecase: validationUseCases)
        let appState = Store<AppState>(AppState())
        let diContainer = DIContainer(appState: appState, services: services)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredValidationUseCases() -> DIContainer.ValidationUseCases {
        let validationUseCase = DefaultValidationUseCase()
        return .init(validationUseCase: validationUseCase)
    }
    
    private static func configuredDBRepositories() -> DIContainer.DBUseCases {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let popularDBUseCase = DefaultArticlesDBUseCase(persistentStore: persistentStore)
        return .init(popularUseCase: popularDBUseCase)
    }
    
    private static func configuredNetworkUseCases(session: URLSession) -> DIContainer.NetworkUseCases {
        let popularUseCase = DefaultPopularArticlesUseCase(session: session, baseURL: NetworkConstants.API_BASE_URL)
        let searchUseCase = DefaultSearchArticlesUseCase(session: session, baseURL: NetworkConstants.API_BASE_URL)
        return .init(popularUseCase: popularUseCase, searchUseCase: searchUseCase)
    }
    
    private static func configuredServices(networkUseCases: DIContainer.NetworkUseCases, dbUseCases: DIContainer.DBUseCases, validationUsecase: DIContainer.ValidationUseCases) -> DIContainer.Services {
        let articleService = DefaultArticleService(
            popularNetworkUsecase: networkUseCases.popularUseCase,
            popularDBUsecase: dbUseCases.popularUseCase,
            searchUsecase: networkUseCases.searchUseCase
        )
        let validationService = DefaultValidationService(validationUsecase: validationUsecase.validationUseCase)
        return .init(articleService: articleService, validationService: validationService)
    }
}

extension DIContainer {
    struct NetworkUseCases {
        let popularUseCase: PopularArticlesUseCase
        let searchUseCase: SearchArticlesUseCase
    }
    struct DBUseCases {
        let popularUseCase: PopularArticlesDBUseCase
    }
    struct ValidationUseCases {
        let validationUseCase: ValidationUseCase
    }
}
