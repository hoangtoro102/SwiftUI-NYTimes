//
//  ListView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        self.content
            .navigationBarTitle("Articles", displayMode: .inline)
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        loadedView(viewModel.articles.value?.0 ?? [])
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.articles {
        case .notRequested:
            notRequestedView
        case .isLoading:
            if viewModel.articles.value?.1.page ?? 0 == 0 {
                loadingView
            }
//        case let .loaded(articles):
//            loadedView(articles)
        case .loaded:
            EmptyView()
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension ListView {
    var notRequestedView: some View {
        Text("").onAppear {
            self.viewModel.firstLoadOrSearch()
        }
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
            self.viewModel.retry()
        })
    }
}

// MARK: - Displaying Content

private extension ListView {
    func loadedView(_ articles: [DisplayItem]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(articles) { article in
                    DetailRow(titleLabel: Text(article.title), dateLabel: Text(article.date))
                        .onAppear {
                            viewModel.loadMoreIfNeed(currentItem: article)
                        }
                }
                if viewModel.articles.value?.1.page ?? 0 > 0,
                    case .isLoading = viewModel.articles {
                    ProgressView()
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListView.ViewModel(container: .preview))
    }
}
