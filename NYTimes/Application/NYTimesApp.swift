//
//  NYTimesApp.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 7/13/22.
//

import SwiftUI

@main
struct NYTimesApp: App {
    var body: some Scene {
        WindowGroup {
            let env = AppEnvironment.initialize()
            let viewModel = ContentView.ViewModel(container: env.container)
            ContentView(viewModel: viewModel)
        }
    }
}
