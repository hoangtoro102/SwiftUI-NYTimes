//
//  ContentView.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            } else {
                MainView(viewModel: .init(container: viewModel.container))
            }
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
