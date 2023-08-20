//
//  PlayerBarView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

struct PlayerBarView : View {
    
    @EnvironmentObject
    private var playerService: PlayerService;
    
    @Binding var show: Bool
    
    var visible = true
    
    var body: some View {
        HStack {
            if(playerService.isNeedShowBarView()) {
                Spacer(minLength: 20)
                Image(systemName: "heart")
                    .imageScale(.large)
                
                VStack {
                    Text(playerService.getPlayingTrack().title).font(.callout)
                    Text(playerService.getPlayingTrack().author.joined(separator: ", ")).font(.caption)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    show = true
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.width < 0 {
                                            playerService.playNext()
                                        }

                                        if value.translation.width > 0 {
                                            playerService.playPrev()
                                        }
                }))

                if(playerService.isPlaying()) {
                    Image(systemName: "pause.fill")
                        .imageScale(.large)
                        .onTapGesture {
                            playerService.pause()
                        }
                }
                else {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                        .onTapGesture {
                            playerService.play()
                        }
                }
                
                Spacer(minLength: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: playerService.isNeedShowBarView() ? 50 : 0)
    }
}
