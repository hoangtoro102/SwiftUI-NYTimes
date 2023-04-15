//
//  ListViewTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import ViewInspector
@testable import NYTimes

extension ListView: Inspectable { }
extension DetailRow: Inspectable { }

final class ListViewTests: XCTestCase {
    let searchArticle = SearchArticle.mockedData[0]
    let article = Article.mockedData[0]
    
    func listView(_ services: DIContainer.Services, type: PopularAPI? = nil, searchArticles: [SearchArticle] = []) -> ListView {
        let container = DIContainer(services: services)
        let viewModel = ListView.ViewModel(container: container, type: type, searchArticles: searchArticles)
        return ListView(viewModel: viewModel)
    }

    func test_list_notRequested() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .notRequested
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(text: ""))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_list_isLoading_initial() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .isLoading(last: nil, cancelBag: CancelBag())
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ActivityIndicatorView.self))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_list_isLoading_refresh() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .isLoading(last: Article.mockedData.map{DisplayItem(popularArticle: $0)}, cancelBag: CancelBag())
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ActivityIndicatorView.self))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_list_isLoading_cancellation() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .isLoading(last: nil, cancelBag: CancelBag())
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ActivityIndicatorView.self))
            try view.find(button: "Cancel loading").tap()
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_list_loaded_from_search() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services, searchArticles: SearchArticle.mockedData)
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(DetailRow.self).find(text: self.searchArticle.headline!.printHeadline!))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 3)
    }
    
    func test_list_loaded_by_popular_type() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .loaded(Article.mockedData.map{DisplayItem(popularArticle: $0)})
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(DetailRow.self).find(text: self.article.title!))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 3)
    }
    
    func test_list_failed() {
        let services = DIContainer.Services.mocked()
        let sut = listView(services)
        sut.viewModel.articles = .failed(NSError.test)
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ErrorView.self))
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_list_failed_retry() {
        let services = DIContainer.Services.mocked(articlesService: [.get(.mostViewed)])
        let sut = listView(services, type: .mostViewed)
        sut.viewModel.articles = .failed(NSError.test)
        let exp = sut.inspection.inspect { view in
            let errorView = try view.find(ErrorView.self)
            try errorView.vStack().button(2).tap()
            services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
