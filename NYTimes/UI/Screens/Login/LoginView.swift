//
//  LoginView.swift
//  NYTimes
//
//  Created by Dung Do on 20/04/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var isShowingRegisterView = false
    
    var body: some View {
        NavigationView {
            self.content
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder private var content: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Text("New York Times")
                    .font(.system(size: 30, weight: .bold))
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading) {
                TextFieldView(description: "Email",
                              placeholder: "Email",
                              type: .emailAddress,
                              error: $viewModel.state.errorEmail,
                              input: $viewModel.state.email)
                .onChange(of: viewModel.state.email) { newValue in
                    viewModel.validateEmail()
                }
                TextFieldView(description: "Password",
                              placeholder: "Password",
                              isSecure: true,
                              error: $viewModel.state.errorPassword,
                              input: $viewModel.state.password)
                .padding(.bottom, 45)
                .onChange(of: viewModel.state.password) { newValue in
                    viewModel.validatePassword()
                }
                ConfirmButtonView(title: "Login", isEnable: viewModel.state.isValid) {
                    appRouter.rootView = .main
                }
                .padding(.top, 62)
                .padding(.bottom, 62)
                HStack(alignment: .center) {
                    Spacer()
                    Text("Don't have an account?")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Button {
                        isShowingRegisterView = true
                    } label: {
                        Text("Register")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.bottom, 60)
            }
            .cornerRadius(25)
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(container: .preview))
    }
}
