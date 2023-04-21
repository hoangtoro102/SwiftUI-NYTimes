//
//  TextFieldView.swift
//  NYTimes
//
//  Created by Dung Do on 20/04/2023.
//

import SwiftUI

struct TextFieldView: View {
    var description: String = ""
    var placeholder: String = ""
    var type: UIKeyboardType = .alphabet
    var isSecure: Bool = false
    @Binding var error: String
    @Binding var input: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .foregroundColor(.black)
                .font(.system(size: 12))
            if isSecure {
                SecureField(placeholder, text: $input)
                    .font(.system(size: 13, weight: .bold))
            } else {
                TextField(placeholder, text: $input)
                    .font(.system(size: 13, weight: .bold))
                    .keyboardType(type)
                    .disableAutocorrection(true)
            }
            Divider()
                .frame(height: 0.5)
                .background(Color.black)
            if !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 8))
            }
        }
        .padding(.top, 35)
        .padding(.horizontal, 30)
    }
}
