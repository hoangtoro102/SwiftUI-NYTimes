//
//  MainView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                self.content
                    .navigationBarTitle("NYT", displayMode: .inline)
                    .toolbar {
                        Button("Logout") {
                            appRouter.route = .login
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    }
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
                NavigationLink(
                    destination: SearchView(viewModel: .init(container: viewModel.container)),
                    tag: "",
                    selection: $viewModel.routingState.searchText) {
                        Text("Search Articles")
                    }
            }
            Section(header: Text("Popular")) {
                ForEach(PopularAPI.allCases) { type in
                    NavigationLink(
                        destination: listView(type: type),
                        tag: type,
                        selection: $viewModel.routingState.type) {
                            Text(type.name)
                        }
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
