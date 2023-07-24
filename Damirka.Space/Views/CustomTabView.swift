//
//  CustomTabView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 23.07.2023.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var tab: Int
    
    var body: some View {
        HStack() {
            
            Group {
                if(tab == 1){
                    Image(systemName: "music.note.house.fill")
                } else {
                    Image(systemName: "music.note.house")
                        .opacity(0.5)
                }
            }
            .foregroundColor(.accentColor)
            .imageScale(.large)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                tab = 1
            }
            
            Group {
                if(tab == 2){
                    Image(systemName: "magnifyingglass")
                        .opacity(1)
                } else {
                    Image(systemName: "magnifyingglass")
                        .opacity(0.5)
                }
            }
            .foregroundColor(.accentColor)
            .imageScale(.large)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                tab = 2
            }
            
            Group {
                if(tab == 3){
                    Image(systemName: "bell.fill")
                } else {
                    Image(systemName: "bell")
                        .opacity(0.5)
                }
            }
            .foregroundColor(.accentColor)
            .imageScale(.large)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                tab = 3
            }
            
            Group {
                if(tab == 4){
                    Image(systemName: "suit.heart.fill")
                } else {
                    Image(systemName: "suit.heart")
                        .opacity(0.5)
                }
            }
            .foregroundColor(.accentColor)
            .imageScale(.large)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                tab = 4
            }

        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        //.background(.ultraThinMaterial)
    }
}
