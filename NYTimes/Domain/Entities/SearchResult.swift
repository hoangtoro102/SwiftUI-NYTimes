//
//  SearchResult.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import Foundation

struct SearchResult: Codable {
    struct Response: Codable {
        let docs: [SearchArticle]?
    }
    
    let response: Response?
}

struct SearchArticle: Codable, Equatable {
    let id: String?
    let headline: Headline?
    let pubDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case headline
        case pubDate = "pub_date"
    }
    
    static func == (lhs: SearchArticle, rhs: SearchArticle) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Headline
public struct Headline: Codable {
    public let main: String?
    public let printHeadline: String?

    enum CodingKeys: String, CodingKey {
        case main
        case printHeadline = "print_headline"
    }
}
