//
//  PopularUseCaseTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import Combine
@testable import NYTimes

final class PopularUseCaseTests: XCTestCase {
    
    private var sut: DefaultPopularArticlesUseCase!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = PopularAPI
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = DefaultPopularArticlesUseCase(session: .mockedResponsesOnly,
                                            baseURL: NetworkConstants.API_BASE_URL)
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    // MARK: - Popular Articles

    func test_getMostViewedArticles() throws {
        let data = PopularResult.mockedData
        try mock(.mostViewed, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadArticles(target: .mostViewed).sinkToResult { result in
            result.assertSuccess(value: data.results ?? [])
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_getMostSharedArticles() throws {
        let data = PopularResult.mockedData
        try mock(.mostShared, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadArticles(target: .mostShared).sinkToResult { result in
            result.assertSuccess(value: data.results ?? [])
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_getMostEmailedArticles() throws {
        let data = PopularResult.mockedData
        try mock(.mostEmailed, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadArticles(target: .mostEmailed).sinkToResult { result in
            result.assertSuccess(value: data.results ?? [])
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: - Helper
    
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}
