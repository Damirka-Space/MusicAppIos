//
//  PlayView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI

struct PlayView: View {
    
    @Binding var show: Bool
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Hello, world!")
            }
            .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .ignoresSafeArea(edges: .all)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.backward")
                        .rotationEffect(Angle.degrees(-90))
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.5)) {
                                show = false
                            }
                        }
                }
            }
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    @State static var show = true
    
    static var previews: some View {
        PlayView(show: $show)
    }
}
