//
//  ProfileView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI
import SafariServices


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ProfileView: View {
    
    @EnvironmentObject
    private var authService: AuthService
    
    @State var showSafariView = false
    
    @State private var username: String = ""
    
    @State private var password: String = ""
    
    var body: some View {
//        VStack {
//            Text("Profile hello world")
//            
//            Text("Test")
//                .font(.system(size: 20))
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(5)
//            
//            Text("Login")
//                .font(.system(size: 20))
//                .padding()
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(5)
//                .onTapGesture {
//                    showSafariView = true
//                    print("Test")
//                }
//            
//            .fullScreenCover(isPresented: $showSafariView) {
//                SafariView(url: URL(string: "https://damirka.space")!)
//            }
//        }
        
        
        
        
        
        switch(authService.result) {
        case .success(let token):
            VStack {
                Text("Вы авторизированы")
            }
            .frame(height: 300, alignment: .center)
        case .failure(let error):
            Text(error.localizedDescription)
        case nil:
            VStack {
                if(!authService.Authorized() && !authService.Processing()) {
                
                    Text("Авторизоваться")
                    
                    Form {
                        
                        Section(header: Text("Ваши данные")) {
                            TextField(text: $username, prompt: Text("Введите имя пользователя")) {
                                Text("Имя пользователя")
                            }
                            SecureField(text: $password, prompt: Text("Введите пароль")) {
                                Text("Пароль")
                            }
                        }
                        
                        Section {
                            Button(action: {
                                authService.login(username: username, password: password)
                            }) {
                                Text("Подтвердить")
                            }
                            .buttonStyle(GrowingButton())
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .background(.white)
                    .scrollContentBackground(.hidden)
                    
                }
                else {
                    ProgressView()
                }
            }
            .frame(height: 300, alignment: .center)
        }
    }
}
