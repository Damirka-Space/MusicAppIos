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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerService)
        }
    }
}
