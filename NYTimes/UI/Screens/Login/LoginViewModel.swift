//
//  LoginViewModel.swift
//  NYTimes
//
//  Created by Dung Do on 20/04/2023.
//

import SwiftUI
import Combine

// MARK: - State

extension LoginView {
    struct LoginState {
        var email: String = ""
        var password: String = ""
        var errorEmail: String = ""
        var errorPassword: String = ""
        var isValid: Bool {
            !email.isEmpty && !password.isEmpty && errorEmail.isEmpty && errorPassword.isEmpty
        }
    }
}

// MARK: - ViewModel

extension LoginView {
    class ViewModel: ObservableObject {
        // State
        @Published var state = LoginState()
        
        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
        }
    }
}
