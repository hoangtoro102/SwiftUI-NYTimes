//
//  NetworkUseCaseTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import Combine
@testable import NYTimes

final class NetworkUseCaseTests: XCTestCase {
    
    private var sut: TestNetworkUseCase!
    private var subscriptions = Set<AnyCancellable>()
    
    private typealias API = TestNetworkUseCase.API
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = TestNetworkUseCase()
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    func test_networkUseCase_success() throws {
        let data = TestNetworkUseCase.TestData()
        try mock(.test, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_parseError() throws {
        let data = Article.mockedData
        try mock(.test, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure("The data couldn’t be read because it isn’t in the correct format.")
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_httpCodeFailure() throws {
        let data = TestNetworkUseCase.TestData()
        try mock(.test, result: .success(data), httpCode: 500)
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure("Unexpected HTTP code: 500")
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_networkingError() throws {
        let error = NSError.test
        try mock(.test, result: Result<TestNetworkUseCase.TestData, Error>.failure(error))
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(error.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_requestURLError() {
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.urlError).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(APIError.invalidURL.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_requestBodyError() {
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.bodyError).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(TestNetworkUseCase.APIError.fail.localizedDescription)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_loadableError() {
        let exp = XCTestExpectation(description: "Completion")
        let expected = APIError.invalidURL.localizedDescription
        sut.load(.urlError)
            .sinkToLoadable { loadable in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(loadable.error?.localizedDescription, expected)
                exp.fulfill()
            }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_networkUseCase_noHttpCodeError() throws {
        let response = URLResponse(url: URL(fileURLWithPath: ""),
                                   mimeType: "example", expectedContentLength: 0, textEncodingName: nil)
        let mock = try Mock(apiCall: API.test, baseURL: sut.baseURL, customResponse: response)
        RequestMocking.add(mock: mock)
        let exp = XCTestExpectation(description: "Completion")
        sut.load(.test).sinkToResult { result in
            XCTAssertTrue(Thread.isMainThread)
            result.assertFailure(APIError.unexpectedResponse.localizedDescription)
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

private extension TestNetworkUseCase {
    func load(_ api: API) -> AnyPublisher<TestData, Error> {
        call(endpoint: api)
    }
}

extension TestNetworkUseCase {
    enum API: APICall {
        
        case test
        case urlError
        case bodyError
        case noHttpCodeError
        
        var path: String {
            if self == .urlError {
                return "😋😋😋"
            }
            return "/test/path"
        }
        var method: String { "POST" }
        var headers: [String: String]? { nil }
        func body() throws -> Data? {
            if self == .bodyError { throw APIError.fail }
            return nil
        }
    }
}

extension TestNetworkUseCase {
    enum APIError: Swift.Error, LocalizedError {
        case fail
        var errorDescription: String? { "fail" }
    }
}

extension TestNetworkUseCase {
    struct TestData: Codable, Equatable {
        let string: String
        let integer: Int
        
        init() {
            string = "some string"
            integer = 42
        }
    }
}
