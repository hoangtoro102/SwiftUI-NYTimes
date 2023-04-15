//
//  SearchUseCaseTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import Combine
@testable import NYTimes

final class SearchUseCaseTests: XCTestCase {
    
    private var sut: DefaultSearchArticlesUseCase!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = SearchAPI
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = DefaultSearchArticlesUseCase(session: .mockedResponsesOnly,
                                            baseURL: NetworkConstants.API_BASE_URL)
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    // MARK: - Search Articles

    func test_search() throws {
        let data = SearchResult.mockedData
        try mock(.search("abc"), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.search(text: "abc").sinkToResult { result in
            result.assertSuccess(value: data.response?.docs ?? [])
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
