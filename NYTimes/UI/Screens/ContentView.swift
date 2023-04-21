//
//  ContentView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

class AppRouter: ObservableObject {
    @Published var rootView: AppRootView = .login
}

extension AppRouter {
    enum AppRootView {
        case login
        case main
    }
}

struct ContentView: View {
    @StateObject var appRouter = AppRouter()
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            } else {
                rootView
                    .environmentObject(appRouter)
            }
        }
    }
    
    @ViewBuilder
    var rootView: some View {
        switch appRouter.rootView {
        case .login:
            LoginView(viewModel: .init(container: viewModel.container))
        case .main:
            MainView(viewModel: .init(container: viewModel.container))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContentView.ViewModel(container: .preview)
        ContentView(viewModel: viewModel)
    }
}

// MARK: - ViewModel

extension ContentView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        let isRunningTests: Bool
        
        init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            self.container = container
            self.isRunningTests = isRunningTests
        }
    }
}
