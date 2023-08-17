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
        List {
            Section.init {
                VStack {
                    AsyncImage(url: URL(string: album.image.url)) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(20.0)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300, alignment: .center)

                    Text(album.title).font(.title2)
                    Text(album.description).font(.title3)
                }
                .frame(width: 350, alignment: .center)
            }
            
            switch(tracksModel.result) {
            case .success(let tracks):
                ForEach(tracks.indices, id: \.self) { tId in
                    TrackView(track: tracks[tId], index: tId + 1, isAlbum: isAlbum)
                        .frame(height: 40)
                        .onTapGesture {
                            self.currentTrackId = tId
                            playTrack()
                        }
                        .listRowBackground(playerService.getId() == album.id && tId == playerService.getPlayingIndex() ? Color.teal : Color.white)
                        //.foregroundColor(tId == currentTrackId ? .accentColor : .black)
                }
                .listRowBackground(Color.white)
                
            case .failure(let error):
                Text(error.localizedDescription)
            case nil:
                ProgressView()
                    .onAppear {
                        self.tracksModel.apiCall(albumId: album.id)
                    }
            }
            Spacer(minLength: 50)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
}
