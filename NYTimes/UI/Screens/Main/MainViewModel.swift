//
//  MainViewModel.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI
import Combine

// MARK: - Routing

extension MainView {
    struct Routing: Equatable {
        enum Route {
            case search
            case popular
        }
        
        var route: Route = .search
    }
}

// MARK: - ViewModel

extension MainView {
    class ViewModel: ObservableObject {
        // State
        @Published var routingState: Routing
        
        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.mainView)
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.mainView] = $0 }
                appState.map(\.routing.mainView)
                    .removeDuplicates()
                    .weakAssign(to: \.routingState, on: self)
            }
        }
    }
}
