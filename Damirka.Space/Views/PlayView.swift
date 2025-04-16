//
//  PlayView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI
import UIKit

struct PlayView: View {
    @Binding var show: Bool
    @Binding var showAnim: ShowAnimation
    
    @EnvironmentObject
    private var playerService: PlayerService;
    
    @State private var speed = 50.0
    @State private var isEditing = false
    
    @State private var size = 250.0
    
    @State private var padding = 10.0
    
    @State private var offset = 0.0
    
    @State private var shadow = 0.0
    
    @State private var shadowOffset = 0.0
    
//    @State private var swipe = false
    
//    @State private var tracks: [TrackEntity?] = []
    
    @State private var t = [
                TrackEntity(id: 1, title: "Test", author: ["Author"], albumId: 0, album: "Album", url: "https://damirka.space/fs/smallImages/34", imageUrl: "https://damirka.space/fs/smallImages/34", metadataImageUrl: "https://damirka.space/fs/smallImages/34", liked: false),
        
                TrackEntity(id: 1, title: "Test2", author: ["Author2"], albumId: 0, album: "Album", url: "https://damirka.space/fs/smallImages/35", imageUrl: "https://damirka.space/fs/smallImages/35", metadataImageUrl: "https://damirka.space/fs/smallImages/35", liked: false),
        
                TrackEntity(id: 1, title: "Test3", author: ["Author3"], albumId: 0, album: "Album", url: "https://damirka.space/fs/smallImages/36", imageUrl: "https://damirka.space/fs/smallImages/36", metadataImageUrl: "https://damirka.space/fs/smallImages/36", liked: false),
        
                TrackEntity(id: 1, title: "Test4", author: ["Author4"], albumId: 0, album: "Album", url: "https://damirka.space/fs/smallImages/33", imageUrl: "https://damirka.space/fs/smallImages/37", metadataImageUrl: "https://damirka.space/fs/smallImages/37", liked: false),
        
                TrackEntity(id: 1, title: "Test5", author: ["Author5"], albumId: 0, album: "Album", url: "https://damirka.space/fs/smallImages/33", imageUrl: "https://damirka.space/fs/smallImages/33", metadataImageUrl: "https://damirka.space/fs/smallImages/33", liked: false),
    ]
    
    var small = 250.0
    
    var large = 300.0
    
    var padSmall = 10.0
    var padLarge = 20.0
    
    var sh = 20.0
    
    var shOf = 10.0
    
    var of = 260.0
    
    // TODO: fix offsets
    
    // 0 130 260 ...
    @State var sf = 130.0
    @State var startOffset = 0.0
    
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
        let tracks = playerService.getPlaylist()
        
        var index = playerService.getPlayingIndex()
        
        var startOffset = sf + Double(index) * -of
        
    
        NavigationStack {
            VStack {
                LazyVStack {
                    LazyHStack(alignment: .center) {
                        
                        Spacer()
                                                    
                        if(tracks!.count > 0) {
                            ForEach(tracks!.indices) { i in
                                let track = tracks![i]
                                
                                let size = i == index ? size : small
                                
                                let shadowOffset = i == index ? shadowOffset : 0.0
                                
                                let shadow = i == index ? shadow : 0.0
                                
                                let padding = i == index ? padding : 0.0
                                
                                let url = i == index ? track.metadataImageUrl : track.imageUrl
                                
                                ZStack {
                                    AsyncImage(url: URL(string: url)) { image in
                                        image.resizable()
                                            .cornerRadius(10.0)
                                            .frame(width: size, height: size)
                                            .shadow(radius: shadow, y: shadowOffset)
                                            .padding(.horizontal, padding)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: size, height: size)
                                            .background(.white)
                                            .cornerRadius(10.0)
                                            .border(.black)
                                    }
                                    .frame(width: size, height: size)
                                    .shadow(radius: shadow, y: shadowOffset)
                                    .padding(.horizontal, padding)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .offset(x: startOffset + offset)
                    .frame(width: 400, height: 300)
                        .padding(.top, 150)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({value in
                                if(tracks!.count > 1) {
                                    offset = value.translation.width
                                }
                            })
                            .onEnded({ value in
    //                            print(value.translation.width)
    //                            print(value.translation.height)
                                if (value.translation.width > small) {
                                                    // left
    //                                print("LEFT")
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        offset = 0
                                        playerService.playPrev()
                                        index = playerService.getPlayingIndex()
                                        startOffset = sf + Double(index) * -of
                                    }
                                }
                                else if (value.translation.width < -small) {
                                                    // right
    //                                print("RIGHT")
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        offset = 0
                                        playerService.playNext()
                                        index = playerService.getPlayingIndex()
                                        startOffset = sf + Double(index) * -of
                                    }
                                }
                                else {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        offset = 0
                                    }
                                }
                                
                                if (value.translation.height < (small / 2)) {
                                                    // up
                                }
                                else if (value.translation.height > (small / 2)) {
                                                    // close on swipe down
                                    close()
                                }
                                
                        }))
                    
                    HStack(alignment: .center) {
                        VStack {
                            if(tracks!.count > 0) {
                                
                                let track = tracks![index]
                                
                                Text(track.title).font(.headline).fontWeight(.regular)
                                    .frame(width: 300, height: 20, alignment: .leading)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)

                                Text(track.author.joined(separator: ", ")).font(.subheadline)
                                    .frame(width: 300, height: 20, alignment: .leading)
                                    .foregroundColor(.white)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 50)
                        
                        HStack {
                            Image(systemName: "ellipsis.circle.fill").imageScale(.large).foregroundStyle(.white)
                        }.frame(maxWidth: .infinity, alignment: .trailing).padding(.trailing, 50)
                    }.frame(maxWidth: .infinity).padding(.top, 40).padding(.bottom, 20)
                    
                    HStack(alignment: .center) {
                        ProgressView(value: playerService.currentTime().seconds, total: playerService.currentItem?.duration.seconds ?? 0.0)
                            .tint(.white)
                    }.padding(.horizontal, 40)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "backward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = 0
                                    playerService.playPrev()
                                    index = playerService.getPlayingIndex()
                                    startOffset = sf + Double(index) * -of
                                }
                            }
                        
                        if(playerService.isPlaying()) {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    playerService.pause()
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        size = small
                                        padding = padSmall
                                        shadow = 0.0
                                        shadowOffset = 0.0
                                    }
                                }.padding(.leading, 30).padding(.trailing, 30)
                        }
                        else {
                            Image(systemName: "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    playerService.play()
                                    
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        size = large
                                        padding = padLarge
                                        shadow = sh
                                        shadowOffset = shOf
                                    }
                                    
                                }.padding(.leading, 30).padding(.trailing, 30)
                        }
                        
                        Image(systemName: "forward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = 0
                                    playerService.playNext()
                                    index = playerService.getPlayingIndex()
                                    startOffset = sf + Double(index) * -of
                                }
                            }
                    }
                    .padding(.top, 50)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 150)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    VStack {
                        let track = tracks![index]
                            
                        AsyncImage(url: URL(string: track.metadataImageUrl)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                                .background(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeOut(duration: 0.5))
                    .contentShape(Rectangle())
                    .blur(radius: 100)
                )
                .onAppear {
                    if(tracks!.count > 0) {
                        sf = Double((tracks!.count - 1)) * 130.0
                        
                        startOffset = sf + Double(index) * -of
                        
                        if(playerService.isPlaying()) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                size = large
                                padding = padLarge
                                shadow = sh
                                shadowOffset = shOf
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.backward")
                        .rotationEffect(Angle.degrees(-90))
                        .onTapGesture {
                            close()
                        }
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                }
            }
            
        }
    }
}

//struct PlayView_Previews: PreviewProvider {
//    @State static var show = true
//    @State static var showAnim = ShowAnimation.HideTab
//    @State private static var player = PlayerService()
//
//    static var previews: some View {
//        PlayView(show: $show, showAnim: $showAnim)
//            .environmentObject(player)
//    }
//}
