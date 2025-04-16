//
//  ContentView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

import SwiftUI

enum ShowAnimation {
    case None
    case Start
    case HideTab
    case End
}

struct ContentView: View {
    @State var show = false
    
    @State var showAnim = ShowAnimation.None
    
    @State var tab = 1
    
    init() {
        UIToolbar.changeAppearance(clear: true)
        
        URLCache.shared.memoryCapacity = 200_000_000 // ~200 MB memory space
        URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space
    }
    
    var body: some View {
        ZStack {

            TabView(selection: $tab) {
                HomeView()
                    .tag(1)
                Text("Search")
                    .tag(2)
                Text("Notification")
                    .tag(3)
                Text("Favourites")
                    .tag(4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if(!show) {
                ZStack {
                    VStack(spacing: 0) {
                        PlayerBarView(show: $show)

                        CustomTabView(tab: $tab)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

            } else {
                ZStack {
                    VStack(spacing: 0) {
                        PlayerBarView(show: $show)
                            .background(.regularMaterial)
                            .offset(y: showAnim == .Start || showAnim == .End ? 0 : -820)
                        
                        CustomTabView(tab: $tab)
                            .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                            .offset(y: showAnim == .Start || showAnim == .End ? 0 : 100)

                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .zIndex(1)
                .onAppear() {
                    showAnim = .Start
                    withAnimation(.easeOut(duration: 0.3)) {
                        showAnim = ShowAnimation.HideTab
                    }
                }
                .onDisappear() {
                    showAnim = .None
                }
                
                ZStack {
                    PlayView(show: $show, showAnim: $showAnim)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: showAnim == .Start || showAnim == .End ? 750 : 0)
            }
        }
        .background(.clear)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State
    private static var authService = AuthService()
    
    @State
    private static var player = PlayerService()
    
    static var previews: some View {
        ContentView()
            .environmentObject(player)
            .environmentObject(authService)
            .onAppear(perform: {
                player.setup(authService: authService)
            })
    }
}
