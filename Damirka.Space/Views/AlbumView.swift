//
//  AlbumView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject
    private var playerService: PlayerService
    
    @StateObject private var tracksModel = TracksModel()
    @State private var currentTrackId = -1
    private let album: AlbumEntity
    private let isAlbum : Bool
    
    init(album albumEntity: AlbumEntity) {
        self.album = albumEntity
        isAlbum = album.albumType == "ALBUM" || album.albumType == "SINGLE"
    }
    
    func playTrack() {
        do {
            try playerService.setPlaylist(tracks: (tracksModel.result?.get())!, id: album.id)
        } catch {
            print(error)
        }
        playerService.playTrack(track: currentTrackId)
    }
    
    var body: some View {
        GeometryReader { gr in
            
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        AsyncImage(url: URL(string: album.image.url)) { image in
                            image.resizable()
                                .scaledToFit()
                                .cornerRadius(20.0)
                        } placeholder: {
                            ProgressView()
                                .scaledToFit()
                                .frame(width: 250, height: 250, alignment: .center)
                                .background(.black)
                                .cornerRadius(20.0)
                        }
                        .frame(width: 250, height: 250, alignment: .center)
                        .cornerRadius(20.0)
                        .contentShape(Rectangle())

                        Text(album.title)
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 2, y: 1)
                            .padding(.top, 10)
                        Text(album.description)
                            .font(.title3)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 2, y: 1)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 100)
                    
                    LazyVStack {
                        Spacer(minLength: 25)
                        switch(tracksModel.result) {
                        case .success(let tracks):
                            ForEach(tracks.indices, id: \.self) { tId in
                                TrackView(track: tracks[tId], index: tId + 1, isAlbum: isAlbum)
                                    .frame(height: 50)
                                    .padding(.horizontal, 20.0)
                                    .onTapGesture {
                                        self.currentTrackId = tId
                                        playTrack()
                                    }
                                    .background(playerService.getId() == album.id && tId == playerService.getPlayingIndex() ? Color.init(red: 0.75, green: 0.75, blue: 0.75) : Color.white)
                            }
                            
                        case .failure(let error):
                            Text(error.localizedDescription)
                        case nil:
                            HStack(alignment: .center) {
                                ProgressView()
                                    .onAppear {
                                        self.tracksModel.apiCall(albumId: album.id)
                                    }
                            }.frame(height: 50)
                                .padding(.horizontal, 20.0)
                        }
                        Spacer(minLength: 200)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .contentShape(Rectangle())
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
                .frame(minHeight: gr.size.height)
                .background(
                    VStack {
                        AsyncImage(url: URL(string: album.image.url)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .background(.gray)
                        }
                    }
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .blur(radius: 100)
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray)

        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AlbumView_Previews: PreviewProvider {
    
    @State
    private static var playerService = PlayerService()
    
    static var previews: some View {
        AlbumView(album:
                    AlbumEntity(id: 35,
                                title: "Выйти и зайти",
                                description: "Научно-технический рэп",
                                image: ImageEntity(id: 1, url: "https://damirka.space/fs/smallImages/36"),
                                albumType: "SINGLE", liked: false)
        )
        .environmentObject(playerService)
    }
}

