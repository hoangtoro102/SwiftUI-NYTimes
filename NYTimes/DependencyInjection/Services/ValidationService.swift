//
//  ValidationService.swift
//  NYTimes
//
//  Created by Dung Do on 21/04/2023.
//

import Foundation
import Combine

typealias ValidationResult = (Bool, String)

protocol ValidationService {
    func validate(email: String) -> AnyPublisher<String, Error>
    func validate(password: String) -> AnyPublisher<String, Error>
}

struct DefaultValidationService: ValidationService {
    let validationUsecase: ValidationUseCase
    
    init(validationUsecase: ValidationUseCase) {
        self.validationUsecase = validationUsecase
    }
    
    func validate(email: String) -> AnyPublisher<String, Error> {
        validationUsecase.validate(email: email)
    }
    
    func validate(password: String) -> AnyPublisher<String, Error> {
        validationUsecase.validate(password: password)
    }
}
