//
//  SearchViewTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import ViewInspector
@testable import NYTimes

extension SearchView: Inspectable { }

final class SearchViewTests: XCTestCase {
    func searchView(_ articles: Loadable<[SearchArticle]>, _ services: DIContainer.Services) -> SearchView {
        let container = DIContainer(services: services)
        let viewModel = SearchView.ViewModel(container: container)
        return SearchView(viewModel: viewModel)
    }
    
    func test_search_notRequested() {
        let services = DIContainer.Services.mocked(articlesService: [.search("")])
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .notRequested))
        sut.viewModel.search()
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(SearchBar.self))
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_search_isLoading_initial() {
        let services = DIContainer.Services.mocked()
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .isLoading(last: nil, cancelBag: CancelBag())))
        XCTAssertNoThrow(try sut.inspect().find(ActivityIndicatorView.self))
        let exp = sut.inspection.inspect { _ in
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_search_isLoading_cancellation() {
        let services = DIContainer.Services.mocked()
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .isLoading(last: nil, cancelBag: CancelBag())))
        XCTAssertNoThrow(try sut.inspect().find(ActivityIndicatorView.self))
        XCTAssertNoThrow(try sut.inspect().find(button: "Cancel loading").tap())
        let exp = sut.inspection.inspect { view in
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_search_loaded() {
        let services = DIContainer.Services.mocked()
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .loaded(SearchArticle.mockedData)))
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(SearchBar.self))
            XCTAssertThrowsError(try view.find(ActivityIndicatorView.self))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_search_failed() {
        let services = DIContainer.Services.mocked()
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .failed(NSError.test)))
        XCTAssertNoThrow(try sut.inspect().find(ErrorView.self))
        let exp = sut.inspection.inspect { view in
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_search_failed_retry() {
        let services = DIContainer.Services.mocked(articlesService: [.search("")])
        let container = DIContainer(services: services)
        let sut = SearchView(viewModel: .init(container: container, articles: .failed(NSError.test)))
        XCTAssertNoThrow(try sut.inspect().find(ErrorView.self))
        XCTAssertNoThrow(try sut.inspect().find(ErrorView.self).vStack().button(2).tap())
        let exp = sut.inspection.inspect { view in
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
