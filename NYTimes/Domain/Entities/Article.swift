//
//  Article.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Foundation

struct Article: Codable, Equatable {
    let id: Int64?
    let title: String?
    let publishedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate = "published_date"
    }
}
