//
//  ListViewModel.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI
import Combine

// MARK: - Routing

extension ListView {
    struct Routing: Equatable {
        var searchText: String = ""
        var type: PopularAPI = .mostViewed
    }
}

// MARK: - State

extension ListView {
    struct State: Equatable {
        
    }
}

// MARK: - ViewModel

extension ListView {
    class ViewModel: ObservableObject {
        
        // State
        @Published var articles: Loadable<PageDisplayItem>
        let popularType: PopularAPI?
        let searchText: String
        
        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer, type: PopularAPI? = nil, searchText: String = "") {
            self.container = container
            self.popularType = type
            self.searchText = searchText
            _articles = .init(initialValue: .notRequested)
        }
        
        // MARK: - Side Effects
        
        func firstLoadOrSearch() {
            if popularType == nil {
                search()
                return
            }
            loadPopular()
        }
        
        func loadPopular() {
            guard let type = popularType else { return }
            container.services.articleService
                .get(articles: loadableSubject(\.articles), type: type)
        }
                
        func search() {
            container.services.articleService
                .search(articles: loadableSubject(\.articles), text: searchText)
        }
        
        func loadMoreIfNeed(currentItem item: DisplayItem?) {
            guard popularType == nil else { return }
            guard let item = item else {
                loadMore()
                return
            }

            let items = articles.value?.0 ?? []
            let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
            if let idx = items.firstIndex(where: { $0.id == item.id }), idx > thresholdIndex {
                loadMore()
            }
        }
        
        func loadMore() {
            guard articles.case != .isLoading else {
                return
            }
            search()
        }
        
        func retry() {
            // TODO: Retry load or search at current page (not next page)
        }
    }
}
