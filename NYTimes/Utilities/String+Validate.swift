//
//  String+Validate.swift
//  NYTimes
//
//  Created by Dung Do on 21/04/2023.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.trim())
    }
    
    func validatePassword() -> Bool {
        return self.trim().count >= 6
    }
}
