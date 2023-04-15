//
//  PageInfo.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 2/14/23.
//

import Foundation

struct PageInfo {
    var page: Int = 0
    
    init(page: Int = 0) {
        self.page = page
    }
}
// https://github.com/nalexn/clean-architecture-swiftui/issues/20
// In case of supporting 3 cases:
/*
 Use case 1: Opening the screen for the first time

 Use case 2: First page is loaded, scrolling to the bottom

 Use Case 3: Refreshing the most recent records
 */
