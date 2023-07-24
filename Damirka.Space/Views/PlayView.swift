//
//  PlayView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI

struct PlayView: View {
    @Binding var show: Bool
    @Binding var showAnim: ShowAnimation
    
    private func close() {
        withAnimation(.easeOut(duration: 0.3)) {
            showAnim = ShowAnimation.End
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            withAnimation(.easeOut(duration: 0.02)) {
                show = false
            }
        })
    }
    
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
                            close()
                        }
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width < 0 {
                                    // left
                                }

                                if value.translation.width > 0 {
                                    // right
                                }
                                if value.translation.height < 0 {
                                    // up
                                }

                                if value.translation.height > 0 {
                                    // close on swipe down
                                    close()
                                }
                            }))
    }
}

struct PlayView_Previews: PreviewProvider {
    @State static var show = true
    @State static var showAnim = ShowAnimation.HideTab
    
    static var previews: some View {
        PlayView(show: $show, showAnim: $showAnim)
    }
}
