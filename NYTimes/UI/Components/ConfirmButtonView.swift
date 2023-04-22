//
//  ConfirmButtonView.swift
//  NYTimes
//
//  Created by Dung Do on 20/04/2023.
//

import SwiftUI

struct ConfirmButtonView: View {
    let title: String
    let isEnable: Bool
    let onTap: ()->()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .background(isEnable ? Color.black : Color.gray)
                .cornerRadius(25)
        }
        .disabled(!isEnable)
        .frame(height: 50)
        .padding(.leading, 25)
        .padding(.trailing, 25)
    }
}
