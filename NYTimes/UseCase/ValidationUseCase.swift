//
//  ValidationUseCase.swift
//  NYTimes
//
//  Created by Dung Do on 21/04/2023.
//

import Foundation
import Combine

protocol ValidationUseCase {
    func validate(email: String) -> AnyPublisher<String, Error>
    func validate(password: String) -> AnyPublisher<String, Error>
}

struct DefaultValidationUseCase: ValidationUseCase {
    func validate(email: String) -> AnyPublisher<String, Error> {
        if email.validateEmail() {
            return Just(email)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
        } else {
            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:"Invalid email!"])
            return Fail(error: error)
                    .eraseToAnyPublisher()
        }
    }
    
    func validate(password: String) -> AnyPublisher<String, Error> {
        if password.validatePassword() {
            return Just(password)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
        } else {
            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:"Invalid password!"])
            return Fail(error: error)
                    .eraseToAnyPublisher()
        }
    }
}
