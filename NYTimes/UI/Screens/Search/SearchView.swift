//
//  SearchView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var isShowingListView = false
    let inspection = Inspection<Self>()
    
    var body: some View {
        if isShowingListView {
            NavigationLink("",
                           destination: listView(searchText: viewModel.articlesSearch.searchText),
                           isActive: $isShowingListView)
        }
        VStack {
            SearchBar(text: $viewModel.articlesSearch.searchText, placeholder: "Search articles here..")
//            Button(action: viewModel.search, label: { Text("Search") })
            Button(action: { isShowingListView = true }, label: { Text("Search") })
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
            self.content
                .onReceive(viewModel.$articles) { articles in
                    switch articles {
                    case .loaded(_):
                        self.isShowingListView = true
                    default: break
                    }
                }
//            loadedView(viewModel.articles.value?.0 ?? [])
            Spacer()
        }
        .navigationBarTitle("Search", displayMode: .inline)
        .onAppear() {
            print("SearchView onAppear")
            self.isShowingListView = false
            viewModel.articles = .notRequested
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.articles {
        case .notRequested, .loaded:
            notRequestedView
        case .isLoading:
            if viewModel.articles.value?.1.page ?? 0 == 0 {
                loadingView
            }
//        case let .loaded(articles):
//            loadedView(articles)
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension SearchView {
    var notRequestedView: some View {
        EmptyView()
    }
    
    var loadingView: some View {
        VStack {
            ActivityIndicatorView()
            Button(action: {
                self.viewModel.articles.cancelLoading()
            }, label: { Text("Cancel loading") })
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.search()
        })
    }
}

// MARK: - Displaying Content

private extension SearchView {
//    func loadedView(_ articles: [DisplayItem]) -> some View {
//        ScrollView {
//            LazyVStack {
//                ForEach(articles) { article in
//                    DetailRow(titleLabel: Text(article.title), dateLabel: Text(article.date))
//                        .onAppear {
//                            viewModel.loadMoreIfNeed(currentItem: article)
//                        }
//                }
//                if viewModel.articles.value?.1.page ?? 0 > 0,
//                    case .isLoading = viewModel.articles {
//                    ProgressView()
//                }
//            }
//        }
//    }
    
    func listView(searchText: String) -> some View {
        ListView(viewModel: .init(container: viewModel.container, searchText: searchText))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(container: .preview))
    }
}
