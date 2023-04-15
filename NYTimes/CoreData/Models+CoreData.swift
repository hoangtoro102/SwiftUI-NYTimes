//
//  Models+CoreData.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 2/13/23.
//

import Foundation
import CoreData

extension ArticleMO: ManagedEntity { }

extension Article {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> ArticleMO? {
        guard let article = ArticleMO.insertNew(in: context), let id = id
            else { return nil }
        article.id = Int64(id)
        article.title = title
        article.publishedDate = publishedDate
        return article
    }
    
    init?(managedObject: ArticleMO) {
        self.init(id: managedObject.id, title: managedObject.title, publishedDate: managedObject.publishedDate)
    }
}
