//
//  ProfileView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI
import SafariServices

struct ProfileView: View {
    
    @State var showSafariView = false
    
    var body: some View {
        VStack {
            Text("Profile hello world")
            
            Text("Test")
                .font(.system(size: 20))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
            
            Text("Login")
                .font(.system(size: 20))
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(5)
                .onTapGesture {
                    showSafariView = true
                    print("Test")
                }
            
            .fullScreenCover(isPresented: $showSafariView) {
                SafariView(url: URL(string: "https://damirka.space")!)
            }
        }
    }
}
