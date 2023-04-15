//
//  MainViewTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import ViewInspector
@testable import NYTimes

extension MainView: Inspectable { }
extension ActivityIndicatorView: Inspectable { }
extension ErrorView: Inspectable { }

final class MainViewTests: XCTestCase {
    func test_main_navigation_to_search_view() {
        let container = DIContainer(services: .mocked())
        let sut = MainView(viewModel: .init(container: container))
        let exp = sut.inspection.inspect { view in
            let navLink = try view.content().find(navigationLink: "Search Articles")
            _ = try navLink.view(SearchView.self).find(where: { try $0.callOnAppear(); return true })
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_main_navigation_to_list_most_viewed() {
        let type = PopularAPI.mostViewed
        let container = DIContainer(services: .mocked(articlesService: [
            .get(type)
        ]))
        let sut = MainView(viewModel: .init(container: container))
        let exp = sut.inspection.inspect { view in
            let navLink = try view.content().find(navigationLink: "Most Viewed")
            _ = try navLink.view(ListView.self).find(where: { try $0.callOnAppear(); return true })
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_main_navigation_to_list_most_shared() {
        let type = PopularAPI.mostShared
        let container = DIContainer(services: .mocked(articlesService: [
            .get(type)
        ]))
        let sut = MainView(viewModel: .init(container: container))
        let exp = sut.inspection.inspect { view in
            let navLink = try view.content().find(navigationLink: "Most Shared")
            _ = try navLink.view(ListView.self).find(where: { try $0.callOnAppear(); return true })
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_main_navigation_to_list_most_emailed() {
        let type = PopularAPI.mostEmailed
        let container = DIContainer(services: .mocked(articlesService: [
            .get(type)
        ]))
        let sut = MainView(viewModel: .init(container: container))
        let exp = sut.inspection.inspect { view in
            let navLink = try view.content().find(navigationLink: "Most Emailed")
            _ = try navLink.view(ListView.self).find(where: { try $0.callOnAppear(); return true })
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - MainView inspection helper
extension InspectableView where View == ViewType.View<MainView> {
    func content() throws -> InspectableView<ViewType.NavigationView> {
        return try geometryReader().navigationView()
    }
}
