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
        
        func validateEmail() {
            let cancelBag = CancelBag()
            container.services.validationService
                .validate(email: state.email)
                .sinkToResult { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.state.errorEmail = ""
                    case .failure(let err):
                        self?.state.errorEmail = err.localizedDescription
                    }
                }
                .store(in: cancelBag)
        }
        
        func validatePassword() {
            let cancelBag = CancelBag()
            container.services.validationService
                .validate(password: state.password)
                .sinkToResult { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.state.errorPassword = ""
                    case .failure(let err):
                        self?.state.errorPassword = err.localizedDescription
                    }
                }
                .store(in: cancelBag)
        }
    }
}
