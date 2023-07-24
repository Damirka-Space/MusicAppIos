//
//  PlayerBarView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

struct PlayerBarView : View {
    
    @Binding var show: Bool
    
    var visible = true
    
    var body: some View {
        HStack {
            if(visible) {
                Spacer(minLength: 20)
                Image(systemName: "heart")
                    .imageScale(.large)
                
                VStack {
                    Text("Text1").font(.headline)
                    Text("Text2").font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.5)) {
                        show = true
                    }
                }
    //            .fullScreenCover(isPresented: $show){
    //                //PlayView(show: $show)
    //            }
                

                Image(systemName: "pause.fill")
                    .imageScale(.large)
                Spacer(minLength: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: visible ? 50 : 0)
    }
}
