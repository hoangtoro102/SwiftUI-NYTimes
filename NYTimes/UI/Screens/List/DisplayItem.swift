//
//  DisplayItem.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/14/22.
//

import Foundation

struct DisplayItem: Identifiable {
    let id: String
    let title: String
    let date: String
    
    init(popularArticle: Article) {
        self.title = popularArticle.title ?? "<Missing title>"
        self.date = popularArticle.publishedDate ?? "<Missing published date>"
        self.id = "\(popularArticle.id ?? 0)"
    }
    
    init(searchArticle: SearchArticle) {
        self.title = searchArticle.headline?.printHeadline ?? "<Missing title>"
        self.date = searchArticle.pubDate ?? "<Missing published date>"
        self.id = searchArticle.id ?? ""
    }
}

extension UUID {
    init(number: Int64) {
        var number = number
        let numberData = Data(bytes: &number, count: MemoryLayout<Int64>.size)

        let bytes = [UInt8](numberData)

        let tuple: uuid_t = (0, 0, 0, 0, 0, 0, 0, 0,
                             bytes[0], bytes[1], bytes[2], bytes[3],
                             bytes[4], bytes[5], bytes[6], bytes[7])

        self.init(uuid: tuple)
    }

    var intValue: Int64? {
        let tuple = self.uuid
        guard tuple.0 == 0 && tuple.1 == 0 && tuple.2 == 0 && tuple.3 == 0 &&
              tuple.4 == 0 && tuple.5 == 0 && tuple.6 == 0 && tuple.7 == 0 else {
                return nil
        }

        let bytes: [UInt8] = [tuple.8, tuple.9, tuple.10, tuple.11,
                              tuple.12, tuple.13, tuple.14, tuple.15]

        let numberData = Data(bytes: bytes)

        let number = numberData.withUnsafeBytes { $0.pointee } as Int64

        return number
    }
}
