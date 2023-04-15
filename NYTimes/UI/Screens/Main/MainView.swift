//
//  MainView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                self.content
                    .navigationBarTitle("NYT", displayMode: .inline)
            }
            .navigationViewStyle(.stack)
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    @ViewBuilder private var content: some View {
        loadedView()
    }
}

// MARK: - Displaying Content

private extension MainView {
    func loadedView() -> some View {
        List {
            Section(header: Text("Search")) {
                NavigationLink("Search Articles") {
                    SearchView(viewModel: .init(container: viewModel.container))
                }
            }
            Section(header: Text("Popular")) {
                NavigationLink("Most Viewed") {
                    listView(type: .mostViewed)
                }
                NavigationLink("Most Shared") {
                    listView(type: .mostShared)
                }
                NavigationLink("Most Emailed") {
                    listView(type: .mostEmailed)
                }
            }
        }
        .listStyle(.grouped)
    }
    
    func listView(type: PopularAPI) -> some View {
        ListView(viewModel: .init(container: viewModel.container, type: type))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(container: .preview))
    }
}
