//
//  SearchViewModel.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI
import Combine

// MARK: - Routing

extension SearchView {
    struct Routing: Equatable {
        var searchText: String = ""
    }
}

// MARK: - Search State

extension SearchView {
    struct ArticlesSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
        fileprivate var canLoadMorePages = true
    }
}

// MARK: - ViewModel

extension SearchView {
    class ViewModel: ObservableObject {
        
        // State
        @Published var articlesSearch = ArticlesSearch()
        @Published var articles: Loadable<PageDisplayItem>
        
        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer, articles: Loadable<PageDisplayItem> = .notRequested) {
            self.container = container
            _articles = .init(initialValue: articles)
//            $articles
//                .filter{$0.case == .loaded}
//                .sink {[weak self] _ in self?.articlesSearch.currentPage += 1  }
//                .store(in: cancelBag)
        }
        
        // MARK: - Side Effects
        
        func search() {
            container.services.articleService
                .search(articles: loadableSubject(\.articles), text: articlesSearch.searchText)
        }
        
        func loadMoreIfNeed(currentItem item: DisplayItem?) {
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
            guard articles.case != .isLoading, articlesSearch.canLoadMorePages else {
                return
            }
            search()
        }
    }
}
