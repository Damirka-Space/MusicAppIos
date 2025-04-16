//
//  Damirka_SpaceApp.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

import SwiftUI

@main
struct Damirka_SpaceApp: App {
    @State
    private var playerService = PlayerService()
    
    @State
    private var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerService)
                .environmentObject(authService)
                .onAppear(perform: {
                    playerService.setup(authService: authService)
                })
        }
    }
}
