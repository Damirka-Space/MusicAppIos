//
//  ContentView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State var show = false
    
    @State var tab = 1
    
    init() {
        UIToolbar.changeAppearance(clear: true)
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

            ZStack {
                VStack(spacing: 0) {
                    PlayerBarView(show: $show)
                    
                    CustomTabView(tab: $tab)
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .zIndex(1)
            .offset(y: show ? 300: 0)
            
            ZStack {
                PlayView(show: $show)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .offset(y: show ? 0: 1000)
        }
        .background(.clear)
    }
    
//    var body: some View {
//        TabView {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "music.note.house")
//                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        PlayerBarView(show: $show)
//                    }
//                }
//
//            Text("Search")
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        PlayerBarView(show: $show)
//                    }
//                }
//            Text("Notification")
//                .tabItem {
//                    Image(systemName: "bell")
//                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        PlayerBarView(show: $show)
//                    }
//                }
//            Text("Favourites")
//                .tabItem {
//                    Image(systemName: "suit.heart")
//                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        PlayerBarView(show: $show)
//                    }
//                }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
