//
//  AppState.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 2/13/23.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct UserData: Equatable {
        /*
         The list of articles (Loadable<[Article]>) used to be stored here.
         It was removed for performing articles' search by name inside a database,
         which made the resulting variable used locally by just one screen (ListView)
         Otherwise, the list of articles could have remained here, available for the entire app.
         */
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var mainView = MainView.Routing()
        var searchView = SearchView.Routing()
        var listView = ListView.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.routing == rhs.routing &&
        lhs.system == rhs.system
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
