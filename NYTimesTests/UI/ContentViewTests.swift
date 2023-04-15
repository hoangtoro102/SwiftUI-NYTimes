//
//  ContentViewTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import ViewInspector
@testable import NYTimes

extension ContentView: Inspectable { }

final class ContentViewTests: XCTestCase {

    func test_content_for_tests() throws {
        let viewModel = ContentView.ViewModel(container: .defaultValue, isRunningTests: true)
        let sut = ContentView(viewModel: viewModel)
        XCTAssertNoThrow(try sut.inspect().group().text(0))
    }
    
    func test_content_for_build() throws {
        let viewModel = ContentView.ViewModel(container: .defaultValue, isRunningTests: false)
        let sut = ContentView(viewModel: viewModel)
        XCTAssertNoThrow(try sut.inspect().group().view(MainView.self, 0))
    }
}
