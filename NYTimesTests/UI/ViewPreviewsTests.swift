//
//  ViewPreviewsTests.swift
//  NYTimesTests
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import XCTest
import ViewInspector
@testable import NYTimes

final class ViewPreviewsTests: XCTestCase {

    func test_contentView_previews() {
        _ = ContentView_Previews.previews
    }
    
    func test_mainView_previews() {
        _ = MainView_Previews.previews
    }
    
    func test_searchView_previews() {
        _ = SearchView_Previews.previews
    }
    
    func test_listView_previews() {
        _ = ListView_Previews.previews
    }
    
    func test_detailRow_previews() {
        _ = DetailRow_Previews.previews
    }
    
    func test_errorView_previews() throws {
        let view = ErrorView_Previews.previews
        try view.inspect().view(ErrorView.self).actualView().retryAction()
    }
}
